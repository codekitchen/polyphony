# frozen_string_literal: true

require_relative 'helper'

class SignalTrapTest < Minitest::Test
  def test_int_signal
    Thread.new { sleep 0.001; Process.kill('INT', Process.pid) }
    assert_raises(Interrupt) { sleep 5 }
  end

  def test_term_signal
    Thread.new { sleep 0.001; Process.kill('TERM', Process.pid) }
    assert_raises(SystemExit) { sleep 5 }
  end

  def test_signal_exception_handling
    i, o = IO.pipe
    pid = Polyphony.fork do
      i.close
      sleep 5
    rescue ::Interrupt => e
      o.puts "3-interrupt"
    ensure
      o.close
    end
    sleep 0.1
    o.close
    Process.kill('INT', pid)
    Thread.current.backend.waitpid(pid)
    buffer = i.read
    assert_equal "3-interrupt\n", buffer
  end

  def test_signal_exception_with_cleanup
    i, o = IO.pipe
    pid = Polyphony.fork do
      i.close
      spin do
        spin do
          sleep
        rescue Polyphony::Terminate
          o.puts "1 - terminated"
        end.await
      rescue Polyphony::Terminate
        o.puts "2 - terminated"
      end.await
    rescue Interrupt
      o.puts "3 - interrupted"
      Fiber.current.shutdown_all_children
    ensure
      o.close
    end
    sleep 0.1
    o.close
    Process.kill('INT', pid)
    Thread.current.backend.waitpid(pid)
    buffer = i.read
    assert_equal "3 - interrupted\n2 - terminated\n1 - terminated\n", buffer
  end

  def test_interrupt_signal_scheduling
    i, o = IO.pipe
    pid = Polyphony.fork do
      i.close
      sleep
    rescue ::Interrupt => e
      o.puts '3-interrupt'
    ensure
      o.close
    end
    o.close
    sleep 0.1
    Process.kill('INT', pid)
    Thread.current.backend.waitpid(pid)
    buffer = i.read
    assert_equal "3-interrupt\n", buffer
  end

  def test_io_in_signal_handler
    i, o = IO.pipe
    pid = Polyphony.fork do
      trap('INT') { o.puts 'INT'; o.close; exit! }
      i.close
      sleep
    ensure
      o.close
    end

    o.close
    sleep 0.1
    Process.kill('INT', pid)
    Thread.current.backend.waitpid(pid)
    buffer = i.read
    assert_equal "INT\n", buffer
  end

  def test_busy_signal_handling
    i, o = IO.pipe
    pid = Polyphony.fork do
      main = Fiber.current
      trap('INT') { o.puts 'INT'; o.close; main.stop }
      i.close
      f1 = spin_loop { snooze }
      f2 = spin_loop { snooze }
      f1.await
    end

    o.close
    sleep 0.1
    Process.kill('INT', pid)
    Thread.current.backend.waitpid(pid)
    buffer = i.read
    assert_equal "INT\n", buffer
  end
end
