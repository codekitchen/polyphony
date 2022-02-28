# frozen_string_literal: true

require 'openssl'
require_relative './socket'

# OpenSSL socket helper methods (to make it compatible with Socket API) and overrides
class ::OpenSSL::SSL::SSLSocket
  def __read_method__
    :readpartial
  end

  alias_method :orig_initialize, :initialize

  # TODO: add docs to all methods in this file
  def initialize(socket, context = nil)
    socket = socket.respond_to?(:io) ? socket.io || socket : socket
    context ? orig_initialize(socket, context) : orig_initialize(socket)
  end

  def dont_linger
    io.dont_linger
  end

  def no_delay
    io.no_delay
  end

  def reuse_addr
    io.reuse_addr
  end

  def fill_rbuff
    data = self.sysread(BLOCK_SIZE)
    if data
      @rbuffer << data
    else
      @eof = true
    end
  end

  alias_method :orig_sysread, :sysread
  def sysread(maxlen, buf = +'')
    # ensure socket is non blocking
    Polyphony.backend_verify_blocking_mode(io, false)
    while true
      case (result = sysread_nonblock(maxlen, buf, exception: false))
      when :wait_readable then Polyphony.backend_wait_io(io, false)
      when :wait_writable then Polyphony.backend_wait_io(io, true)
      else return result
      end
    end
  end

  alias_method :orig_syswrite, :syswrite
  def syswrite(buf)
    # ensure socket is non blocking
    Polyphony.backend_verify_blocking_mode(io, false)
    while true
      case (result = write_nonblock(buf, exception: false))
      when :wait_readable then Polyphony.backend_wait_io(io, false)
      when :wait_writable then Polyphony.backend_wait_io(io, true)
      else
        return result
      end
    end
  end

  def flush
    # osync = @sync
    # @sync = true
    # do_write ""
    # return self
    # ensure
    # @sync = osync
  end

  alias_method :orig_read, :read
  def read(maxlen = nil, buf = nil, buf_pos = 0)
    return readpartial(maxlen, buf, buf_pos) if buf

    buf = +''
    return readpartial(maxlen, buf) if maxlen

    while true
      readpartial(4096, buf, -1)
    end
  rescue EOFError
    buf
  end

  def readpartial(maxlen, buf = +'', buffer_pos = 0, raise_on_eof = true)
    if buffer_pos != 0
      if (result = sysread(maxlen, +''))
        if buffer_pos == -1
          result = buf + result
        else
          result = buf[0...buffer_pos] + result
        end
      end
    else
      result = sysread(maxlen, buf)
    end

    raise EOFError if !result && raise_on_eof
    result
  end

  def read_loop(maxlen = 8192)
    while (data = sysread(maxlen))
      yield data
    end
  end
  alias_method :recv_loop, :read_loop

  alias_method :orig_peeraddr, :peeraddr
  def peeraddr(_ = nil)
    orig_peeraddr
  end
end

# OpenSSL socket helper methods (to make it compatible with Socket API) and overrides
class ::OpenSSL::SSL::SSLServer
  attr_reader :ctx

  alias_method :orig_accept, :accept
  def accept
    # when @ctx.servername_cb is set, we use a worker thread to run the
    # ssl.accept call. We need to do this because:
    # - We cannot switch fibers inside of the servername_cb proc (see
    #   https://github.com/ruby/openssl/issues/415)
    # - We don't want to stop the world while we're busy provisioning an ACME
    #   certificate
    if @use_accept_worker.nil?
      if (@use_accept_worker = use_accept_worker_thread?)
        start_accept_worker_thread
      end
    end

    # STDOUT.puts 'SSLServer#accept'
    sock, = @svr.accept
    # STDOUT.puts "- raw sock: #{sock.inspect}"
    begin
      ssl = OpenSSL::SSL::SSLSocket.new(sock, @ctx)
      # STDOUT.puts "- ssl sock: #{ssl.inspect}"
      ssl.sync_close = true
      if @use_accept_worker
        # STDOUT.puts "- send to accept worker"
        @accept_worker_fiber << [ssl, Fiber.current]
        # STDOUT.puts "- wait for accept worker"
        r = receive
        # STDOUT.puts "- got reply from accept worker: #{r.inspect}"
        r.invoke if r.is_a?(Exception)
      else
        ssl.accept
      end
      ssl
    rescue Exception => e
      # STDOUT.puts "- accept exception: #{e.inspect}"
      if ssl
        ssl.close
      else
        sock.close
      end
      raise e
    end
  end

  def start_accept_worker_thread
    fiber = Fiber.current
    @accept_worker_thread = Thread.new do
      fiber << Fiber.current
      loop do
        # STDOUT.puts "- accept_worker wait for work"
        socket, peer = receive
        # STDOUT.puts "- accept_worker got socket from peer #{peer.inspect}"
        socket.accept
        # STDOUT.puts "- accept_worker accept returned"
        peer << socket
        # STDOUT.puts "- accept_worker sent socket back to peer"
      rescue Polyphony::BaseException
        raise
      rescue Exception => e
        # STDOUT.puts "- accept_worker error: #{e}"
        peer << e if peer
      end
    end
    @accept_worker_fiber = receive
  end

  def use_accept_worker_thread?
    !!@ctx.servername_cb
  end

  alias_method :orig_close, :close
  def close
    @accept_worker_thread&.kill
    orig_close
  end

  def accept_loop(ignore_errors = true)
    loop do
      yield accept
    rescue SystemCallError, StandardError => e
      raise e unless ignore_errors
    end
  end
end
