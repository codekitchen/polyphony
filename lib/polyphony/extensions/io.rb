# frozen_string_literal: true

require 'open3'

# IO extensions
class ::IO
  class << self
    alias_method :orig_binread, :binread

    # TODO: add docs to all methods in this file
    def binread(name, length = nil, offset = nil)
      File.open(name, 'rb:ASCII-8BIT') do |f|
        f.seek(offset) if offset
        length ? f.read(length) : f.read
      end
    end

    alias_method :orig_binwrite, :binwrite
    def binwrite(name, string, offset = nil)
      File.open(name, 'wb:ASCII-8BIT') do |f|
        f.seek(offset) if offset
        f.write(string)
      end
    end

    EMPTY_HASH = {}.freeze

    # alias_method :orig_foreach, :foreach
    # def foreach(_name, _sep = $/, _limit = nil, _getline_args = EMPTY_HASH,
    #             &_block)
    #   # IO.orig_read(name).each_line(&block)
    #   raise NotImplementedError

    #   # if sep.is_a?(Integer)
    #   #   sep = $/
    #   #   limit = sep
    #   # end
    #   # File.open(name, 'r') do |f|
    #   #   f.each_line(sep, limit, getline_args, &block)
    #   # end
    # end

    alias_method :orig_read, :read
    def read(name, length = nil, offset = nil, opt = EMPTY_HASH)
      if length.is_a?(Hash)
        opt = length
        length = nil
      end
      File.open(name, opt[:mode] || 'r') do |f|
        f.seek(offset) if offset
        length ? f.read(length) : f.read
      end
    end

    # alias_method :orig_readlines, :readlines
    # def readlines(name, sep = $/, limit = nil, getline_args = EMPTY_HASH)
    #   File.open(name, 'r') do |f|
    #     f.readlines(sep, limit, getline_args)
    #   end
    # end

    alias_method :orig_write, :write
    def write(name, string, offset = nil, opt = EMPTY_HASH)
      File.open(name, opt[:mode] || 'w') do |f|
        f.seek(offset) if offset
        f.write(string)
      end
    end

    alias_method :orig_popen, :popen
    def popen(cmd, mode = 'r')
      return orig_popen(cmd, mode) unless block_given?

      Open3.popen2(cmd) { |_i, o, _t| yield o }
    end

    def splice(src, dest, maxlen)
      Polyphony.backend_splice(src, dest, maxlen)
    end

    if RUBY_PLATFORM =~ /linux/
      def double_splice(src, dest)
        Polyphony.backend_double_splice(src, dest)
      end
    
      def tee(src, dest, maxlen)
        Polyphony.backend_tee(src, dest, maxlen)
      end
    end
  end
end

# IO instance method patches
class ::IO
  def __read_method__
    :backend_read
  end

  def __write_method__
    :backend_write
  end

  # def each(sep = $/, limit = nil, chomp: nil)
  #   sep, limit = $/, sep if sep.is_a?(Integer)
  # end
  # alias_method :each_line, :each

  # def each_byte
  # end

  # def each_char
  # end

  # def each_codepoint
  # end

  alias_method :orig_getbyte, :getbyte
  def getbyte
    char = getc
    char ? char.getbyte(0) : nil
  end

  alias_method :orig_getc, :getc
  def getc
    return @read_buffer.slice!(0) if @read_buffer && !@read_buffer.empty?

    @read_buffer ||= +''
    Polyphony.backend_read(self, @read_buffer, 8192, false, -1)
    return @read_buffer.slice!(0) if !@read_buffer.empty?

    nil
  end

  alias_method :orig_read, :read
  def read(len = nil, buf = nil, buf_pos = 0)
    if buf
      return Polyphony.backend_read(self, buf, len, true, buf_pos)
    end

    @read_buffer ||= +''
    result = Polyphony.backend_read(self, @read_buffer, len, true, -1)
    return nil unless result

    already_read = @read_buffer
    @read_buffer = +''
    already_read
  end

  alias_method :orig_readpartial, :read
  def readpartial(len, str = +'', buffer_pos = 0, raise_on_eof = true)
    result = Polyphony.backend_read(self, str, len, false, buffer_pos)
    raise EOFError if !result && raise_on_eof

    result
  end

  alias_method :orig_write, :write
  def write(str, *args)
    Polyphony.backend_write(self, str, *args)
  end

  alias_method :orig_write_chevron, :<<
  def <<(str)
    Polyphony.backend_write(self, str)
    self
  end

  alias_method :orig_gets, :gets
  def gets(sep = $/, _limit = nil, _chomp: nil)
    if sep.is_a?(Integer)
      sep = $/
      _limit = sep
    end
    sep_size = sep.bytesize

    @read_buffer ||= +''

    while true
      idx = @read_buffer.index(sep)
      return @read_buffer.slice!(0, idx + sep_size) if idx

      result = readpartial(8192, @read_buffer, -1)
      return nil unless result
    end
  rescue EOFError
    return nil
  end

  # def print(*args)
  # end

  # def printf(format, *args)
  # end

  # def putc(obj)
  # end

  LINEFEED = "\n"
  LINEFEED_RE = /\n$/.freeze

  alias_method :orig_puts, :puts
  def puts(*args)
    if args.empty?
      write LINEFEED
      return
    end

    idx = 0
    while idx < args.size
      arg = args[idx]
      args[idx] = arg = arg.to_s unless arg.is_a?(String)
      if arg =~ LINEFEED_RE
        idx += 1
      else
        args.insert(idx + 1, LINEFEED)
        idx += 2
      end
    end

    write(*args)
    nil
  end

  # def readbyte
  # end

  # def readchar
  # end

  # def readline(sep = $/, limit = nil, chomp: nil)
  # end

  # def readlines(sep = $/, limit = nil, chomp: nil)
  # end

  alias_method :orig_write_nonblock, :write_nonblock
  def write_nonblock(string, _options = {})
    write(string)
  end

  alias_method :orig_read_nonblock, :read_nonblock
  def read_nonblock(maxlen, buf = nil, _options = nil)
    buf ? readpartial(maxlen, buf) : readpartial(maxlen)
  end

  def read_loop(maxlen = 8192, &block)
    Polyphony.backend_read_loop(self, maxlen, &block)
  end

  def feed_loop(receiver, method = :call, &block)
    Polyphony.backend_feed_loop(self, receiver, method, &block)
  end

  def wait_readable(timeout = nil)
    if timeout
      move_on_after(timeout) do
        Polyphony.backend_wait_io(self, false)
        self
      end
    else
      Polyphony.backend_wait_io(self, false)
      self
    end
  end

  def wait_writable(timeout = nil)
    if timeout
      move_on_after(timeout) do
        Polyphony.backend_wait_io(self, true)
        self
      end
    else
      Polyphony.backend_wait_io(self, true)
      self
    end
  end

  def splice_from(src, maxlen)
    Polyphony.backend_splice(src, self, maxlen)
  end

  if RUBY_PLATFORM =~ /linux/
    def tee_from(src, maxlen)
      Polyphony.backend_tee(src, self, maxlen)
    end
  end
end
