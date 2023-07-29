## 1.5 2023-07-28

- Refactor backend_await in io_uring backend
- Fix calling `Timeout.timeout` with `nil` or `0` (#114)
- Rework support for io_uring multishot accept
- Combine SQE submission and waiting for CQE into a single syscall
- Use io_uring for closing a `Polyphony::Pipe`, removing call to `close()`

## 1.4 2023-07-01

- Implement concurrent `IO#close`
- Improve docs
- Use only positional arguments in `IO#read` and `IO#readpartial` (#109 @floriandejonckheere)

## 1.3 2023-06-23

- Improve cancellation doc page
- Fix linking to liburing under certain conditions (#107)
- Fix reference to `Socket::ZERO_LINGER` (#106 @floriandejonckheere)
- Handle error when calling `pidfd_open`

## 1.2 2023-06-17

- Require Ruby 3.1 or newer
- Add cancellation doc page
- Cleanup code
- Accept array of fiber in `Fiber.await` (in addition to accepting multiple fibers)
- Automatically create backend for thread if not already created (#100)
- Fix trap API when used with debug gem (#100)

## 1.1.1 2023-06-08

- Minor improvements to documentation

## 1.1 2023-06-08

- Add advanced I/O doc page
- Add `Fiber#receive_loop` API

## 1.0.2 2023-05-28

- Remove liburing man files from gemspec (#103)

## 1.0.1 2023-05-14

- Add cheat-sheet
- Improve and bring up to date doc files: overview, tutorial, FAQ
- Fix image refs in docs (#99) (thanks @paulhenrich)

## 1.0 2023-05-11

- More work on docs.

## 0.99.1 2023-05-08

- Reorganize docs, use Yard for all docs.

## 0.99 2023-03-09

- Add missing Mutex API methods (#76)
- Fix `IO.foreach` and `IO#each_line` (#74)
- Fix `SSLServer#accept_loop` (#59)
- Update liburing

## 0.98 2023-03-08

- Add basic support for UDP sockets
- Fix `IO#read` to return empty string when reading length zero
- Fix hang on `require 'polyphony'` in irb session

## 0.97 2023-02-28

- Fix working with IRB (#5)

## 0.96 2023-02-11
 - Rework Redis client adapter
- Fix working with Pry (#95, thanks @floriandejonckheere)
- Improve compatibility with Enumerator and other APIs.

## 0.95 2023-01-16

- Remove support for Ruby 2.7
- Add support for explicit Enumerator (external enumeration) (#93)
- Fix `Socket#readpartial`
- Fix `receive_all_pending` docs (#92)
- Improve linux kernel version detection
- Update liburing
- Always reset SQE user data in io_uring backend

## 0.94 2022-10-03

- Fix linux kernel version detection (#89)

## 0.93 2022-04-05

- Add support for IO::Buffer in Ruby 3.1 (#80)

## 0.92 2022-04-04

- Fix plice on non-Linux OS
- Integrate functionality of `IO.splice_to_eof` into `IO.splice` (#87)

## 0.91 2022-03-23

- Add pipe examples
- Implement `Backend#double_splice_to_eof` (io_ring only)
- Improve safety of tracing

## 0.90 2022-03-21

- Fix possible compilation error on Ruby 2.7.5 (#79)

## 0.89 2022-03-21

- Implement compression/decompression to/from strings (#86)

## 0.88 2022-03-18

- Improve IO stream compression utilities (release GVL, cleanup on exception)

## 0.87 2022-03-17

- Fix compilation on non-Linux OSes

## 0.86 2022-03-14

- Fix gemspec

## 0.85 2022-03-13

- Reduce write ops in `IO.gzip` (#77)
- Add support for read/write method detection for compression/decompression
  methods (#77)
- Improve `Fiber#shutdown_all_children`
- Improve io_uring `wait_event` implementation (share single I/O poll across
  multiple fibers)
- Fix io_uring `write` file offset

## 0.84 2022-03-11

- Implement `IO.tee` (#82)
- Implement `IO#tee_from` (#81)
- Bundle liburing as git submodule

## 0.83 2022-03-10

- Implement `Polyphony::Pipe` class, `Polyphony.pipe` method (#83)
- Add `IO.splice`, `IO.splice_to_eof` (#82)
- Implement compression/decompression methods (#77)

## 0.82 2022-03-04

- Use `POLYPHONY_LIBEV` instead of `POLYPHONY_USE_LIBEV` environment variable
- Add support for working with raw buffers (#78)

## 0.81.1 2022-03-03

- Fix `Backend_recv` regression

## 0.81 2022-03-03

- Restore public visibility for `Polyphony::Process.kill_process`
- Restore public visibility for `Polyphony::Net.setup_alpn`

## 0.80 2022-02-28

- Prevent reentry into `trace_proc`
- Rename `__parser_read_method__` to `__read_method__`
- Rename `ResourcePool#preheat!` to `#fill`.
- Remove ability to use `#cancel_after` or `#move_on` without a block
- Add #move_on alias to `Fiber#interrupt`
- Allow specifying exception in `Fiber#cancel`
- Remove deprecated `Polyphony::Channel` class

## 0.79 2022-02-19

- Overhaul trace events system (#73)

## 0.78 2022-02-16

- Fix Polyphony::Queue API compatibility (#72)

## 0.77 2022-02-07

- Fix behaviour of signal traps (#71)

## 0.76 2022-02-06

- Comment out `Backend_close` API (#70)

## 0.75 2022-02-04

- Fix handling of MoveOn on main fiber of forked process
- Ensure SSLSocket underlying socket is in nonblocking mode
- Add `Polyphony.backend_verify_blocking_mode` API
- Fix address resolution for hostnames with IPv6 address
- Improve behaviour of OOB fiber
- Include caller in `fiber_switchpoint` trace

## 0.74 2022-02-01

- Add support for IPv6 (#69)
- Override TCPSocket.open

## 0.73.1 2021-12-17

- Fix Gemfile.lock

## 0.73 2021-12-16

- Refactor core extensions into separate files for each class
- Improve compatibility with Ruby 3.1
- Improve accuracy of `timer_loop`

## 0.72 2021-11-22

- Add support for supervising added child fibers
- Do not use io_uring under LinuxKit (#66)
- Fix error message in `Fiber#restart`
- refactor `runqueue_ring_buffer_mark`
- Fix setting up test server on random port
- Enhance `Fiber#supervise`
  - Add support for specifying `restart: true` (same as `restart: :always`)
  - Add support for supervising child fibers (when fibers are not specified)
- Add `Fiber#attach_all_children_to`
- Improve `SSLServer#accept` when `servername_cb` is set
- Fix `#supervise` in Ruby 3.0

## 0.71 2021-08-20

- Fix compilation on Ruby 3.0

## 0.70 2021-08-19

- New implementation for `#supervise`
- Reset backend state and runqueue on fork

## 0.69 2021-08-16

- Rename `#__polyphony_read_method__` to `#__parser_read_method__`

## 0.68 2021-08-13

- Fix missing default value in socket classes' `#readpartial`
- Fix linking of operations in `Backend#chain` (io_uring version)
- Rename `Fiber#attach` to `Fiber#attach_to`
- Expose original `SSLServer#accept`

## 0.67 2021-08-06

- Improve fiber monitoring
- Add fiber parking (a parked fiber is prevented from running). This is in
  preparation for the upcoming work on an integrated debugger.

## 0.66 2021-08-01

- Fix all splicing APIs on non-linux OSes (#63)
- Add GC marking of buffers when cancelling read/write ops in io_uring backend

## 0.65 2021-07-29

- Add `#__parser_read_method__` method for read method detection

## 0.64 2021-07-26

- Add optional raise_on_eof argument to `#readpartial`

## 0.63 2021-07-26

- Add support for specifying buf and buf_pos in `IO#read`
- Fix `Socket#read` to work and conform to `IO#read` interface

## 0.62 2021-07-21

- Add `runqueue_size` to backend stats

## 0.61 2021-07-20

- Add more statistics, move stats to `Backend#stats`

## 0.60 2021-07-15


- Fix linux version detection (for kernel version > 5.9)
- Fix op ctx leak in io_uring backend (when polling for I/O readiness)
- Add support for appending to buffer in `Backend#read`, `Backend#recv` methods
- Improve anti-event starvation mechanism
- Redesign fiber monitoring mechanism
- Implement `Fiber#attach`
- Add optional maxlen argument to `IO#read_loop`, `Socket#recv_loop` (#60)
- Implement `Fiber#detach` (#52)

## 0.59.1 2021-06-28

- Accept fiber tag in `Polyphony::Timer.new`

## 0.59 2021-06-28

- Redesign tracing mechanism and API - now completely separated from Ruby core
  trace API
- Refactor C code - move run queue into backend

## 0.58 2021-06-25

- Implement `Thread#idle_gc_period`, `#on_idle` (#56)
- Implement `Backend#idle_block=` (#56)

## 0.57.0 2021-06-23

- Implement `Backend#splice_chunks` method for both libev and io_uring backends
- Improve waiting for readiness in libev `Backend#splice`, `#splice_to_eof`
- Enable splice op in libev `Backend#chain` for non-Linux OS

## 0.56.0 2021-06-22

- Implement fake `Backend#splice`, `Backend#splice_to_eof` methods for non-Linux
  OS

## 0.55.0 2021-06-17

- Finish io_uring implementation of Backend#chain
- Reimplement io_uring op_context acquire/release algorithm (using ref count)
- Fix #gets on sockets
- Redesign event anti-starvation mechanism

## 0.54.0 2021-06-14

- Implement Mutex#owned?, #locked? (#50)
- Fix arity for SSLSocket#peeraddr (#55)
- Add missing SSLServer#accept_loop method (#53)
- Fix SSLSocket buffering behaviour
- Add recv_loop alias for SSLSocket (#54)

## 0.53.2 2021-05-10

- Remove `splice` methods on libev backend on non-Linux OS (#43)

## 0.53.0 2021-04-23

- Implement `Backend#splice`, `Backend#splice_to_eof`, along with `IO#splice`,
  `IO#splice_to_eof`

## 0.52.0 2021-02-28

- Polyphony is now compatible with Ruby 3.0
- Add `Backend#sendv` method for sending multiple strings
- Accept flags argument in `Backend#send` (#48)
- Fix io_uring backend on Ruby 3.0 (#47)
- Implement C-based public backend API: `Polyphony.backend_XXXX` methods
- libev backend: Use` pidfd_open` for Linux 5.3+, otherwise use a libev child watcher
- Use `:call` as default method in `#feed_loop`

## 0.51.0 2021-02-02

- Implement `IO#feed_loop`, `Socket#feed_loop`
- Fix error handling in `Process.kill_and_await`

## 0.50.1 2021-01-31

- Set `IOSQE_ASYNC` flag in io_uring backend
- Fix error handling in `Backend#waitpid`
- Reimplement libev backend's `#waitpid` by using pidfd_open (in similar manner
  to the io_uring backend)

## 0.50.0 2021-01-28

- Use `Process::CLOCK_MONOTONIC` in Timer
- Add `Timer#sleep`, `Timer#after`, `Timer#every`
- Prevent fiber from being resumed after terminating
- Add `Thread#fiber_index_of` method
- Use `Backend#wait_event` in `Fiber#await`

## 0.49.2 2021-01-19

- Fix hang with 100s or more child fibers when terminating
- Fix double pending_count increment in io_uring backend

## 0.49.1 2021-01-13

- Use `TCPSocket` instead of `Socket` in `Net.tcp_connect`
- Catch `Errno::ERSCH` in `Process.kill_and_await`
- Set io_uring queue size to 2048

## 0.49.0 2021-01-11

- Implement `Polyphony::Timer` for performant timeouts

## 0.48.0 2021-01-05

- Implement graceful shutdown
- Add support for `break` / `StopIteration` in `spin_loop`
- Fix `IO#gets`, `IO#readpartial`

## 0.47.5.1 2020-11-20

- Add missing `Socket#accept_loop` method

## 0.47.5 2020-11-20

- Add `socket_class` argument to `Backend#accept`, `Backend#accept_loop`
- Fix `#supervise` to stop when all children fibers are done

## 0.47.4 2020-11-14

- Add support for Unix sockets

## 0.47.3 2020-11-12

- Enable I/O in signal handlers (#45)
- Accept `:interval` argument in `#spin_loop`

## 0.47.2 2020-11-10

- Fix API compatibility between TCPSocket and IO

## 0.47.0 2020-11-10

- Implement `#spin_scope` used for creating blocking fiber scopes
- Reimplement `move_on_after`, `cancel_after`, `Timeout.timeout` using
  `Backend#timeout` (avoids creating canceller fiber for most common use case)
- Implement `Backend#timeout` API
- Implemented capped queues

## 0.46.1 2020-11-04

- Add `TCPServer#accept_loop`, `OpenSSL::SSL::SSLSocket#accept_loop` method
- Fix compilation error on MacOS (#43)
- Fix backtrace for `Timeout.timeout`
- Add `Backend#timer_loop`

## 0.46.0 2020-10-08

- Implement [io_uring backend](https://github.com/digital-fabric/polyphony/pull/44)

## 0.45.5 2020-10-04

- Fix compilation error (#43)
- Add support for resetting move_on_after, cancel_after timeouts
- Optimize anti-event starvation polling
- Implement optimized runqueue for better performance
- Schedule parent with priority on uncaught exception
- Fix race condition in `Mutex#synchronize` (#41)

## 0.45.4 2020-09-06

- Improve signal trapping mechanism

## 0.45.3 2020-09-02

- Don't swallow error in `Process#kill_and_await`
- Add `Fiber#mailbox` attribute reader
- Fix bug in `Fiber.await`
- Implement `IO#getc`, `IO#getbyte`

## 0.45.2 2020-08-03

- Rewrite `Fiber#<<`, `Fiber#await`, `Fiber#receive` in C

## 0.45.1 2020-08-01

- Fix Net::HTTP compatibility
- Fix fs adapter
- Improve performance of IO#puts
- Mutex#synchronize
- Fix Socket#connect
- Cleanup code
- Improve support for Ruby 3 keyword args

## 0.45.0 2020-07-29

- Cleanup code
- Rename `Agent` to `Backend`
- Implement `Polyphony::ConditionVariable`
- Fix Kernel.system

## 0.44.0 2020-07-25

- Fix reentrant `ResourcePool` (#38)
- Add `ResourcePool#discard!` (#35)
- Add `Mysql2::Client` and `Sequel::ConnectionPool` adapters (#35)
- Reimplement `Kernel.trap` using `Fiber#interject`
- Add `Fiber#interject` for running arbitrary code on arbitrary fibers (#39)

## 0.43.11 2020-07-24

- Dump uncaught exception info for forked process (#36)
- Add additional socket config options (#37)
  - :reuse_port (`SO_REUSEPORT`)
  - :backlog (listen backlog, default `SOMAXCONN`)
- Fix possible race condition in Queue#shift (#34)

## 0.43.10 2020-07-23

- Fix race condition when terminating fibers (#33)
- Fix lock release in `Mutex` (#32)
- Virtualize agent interface
- Implement `LibevAgent_connect`

## 0.43.9 2020-07-22

- Rewrite `Channel` using `Queue`
- Rewrite `Mutex` using `Queue`
- Reimplement `Event` in C to prevent cross-thread race condition
- Reimplement `ResourcePool` using `Queue`
- Implement `Queue#size`

## 0.43.8 2020-07-21

- Rename `LibevQueue` to `Queue`
- Reimplement Event using `Agent#wait_event`
- Improve Queue shift queue performance
- Introduce `Agent#wait_event` API for waiting on asynchronous events
- Minimize `fcntl` syscalls in IO operations

## 0.43.7 2020-07-20

- Fix memory leak in ResourcePool (#31)
- Check and adjust file position before reading (#30)
- Minor documentation fixes

## 0.43.6 2020-07-18

- Allow brute-force interrupting with second Ctrl-C
- Fix outgoing SSL connections (#28)
- Improve Fiber#await_all_children with many children
- Use `writev` for writing multiple strings
- Add logo (thanks [Gerald](https://webocube.com/)!)

## 0.43.5 2020-07-13

- Fix `#read_nonblock`, `#write_nonblock` for `IO` and `Socket` (#27)
- Patch `Kernel#p`, `IO#puts` to issue single write call
- Add support for multiple arguments in `IO#write` and `LibevAgent#write`
- Use LibevQueue for fiber run queue
- Reimplement LibevQueue as ring buffer

## 0.43.4 2020-07-09

- Reimplement Kernel#trap
- Dynamically allocate read buffer if length not given (#23)
- Prevent CPU saturation on infinite sleep (#24)

## 0.43.3 2020-07-08

- Fix behaviour after call to `Process.daemon` (#8)
- Replace core `Queue` class with `Polyphony::Queue` (#22)
- Make `ResourcePool` reentrant (#1)
- Accept `:with_exception` argument in `cancel_after` (#16)

## 0.43.2 2020-07-07

- Fix sending Redis commands with array arguments (#21)

## 0.43.1 2020-06

- Fix compiling C-extension on MacOS (#20)

## 0.43 2020-07-05

- Add IO#read_loop
- Fix OpenSSL extension
- More work on docs

## 0.42 2020-07-03

- Improve documentation
- Fix backtrace on SIGINT
- Implement LibevAgent#accept_loop, #read_loop
- Move ref counting from thread to agent
- Short circuit switchpoint if continuing with the same fiber
- Always do a switchpoint in #read, #write, #accept

## 0.41 2020-06-27

- Introduce System Agent design, remove all `Gyro` classes

## 0.40 2020-05-04

- More improvements to stability after fork

## 0.38 2020-04-13

- Fix post-fork segfault if parent process has multiple threads with active
  watchers

## 0.37 2020-04-07

- Explicitly kill threads on exit to prevent possible segfault
- Remove Modulation dependency

## 0.36 2020-03-31

- More docs
- More C code refactoring
- Fix freeing for active child, signal watchers

## 0.35 2020-03-29

- Rename `Fiber#cancel!` to `Fiber#cancel`
- Rename `Gyro::Async#signal!` to `Gyro::Async#signal`
- Use `Fiber#auto_watcher` in thread pool, thread extension
- Implement `Fiber#auto_io` for reusing IO watcher instances
- Refactor C code

## 0.34 2020-03-25

- Add `Fiber#auto_watcher` mainly for use in places like `Gyro::Queue#shift`
- Refactor C extension
- Improved GC'ing for watchers
- Implement process supervisor (`Polyphony::ProcessSupervisor`)
- Improve fiber supervision
- Fix forking behaviour
- Use correct backtrace for fiber control exceptions
- Allow calling `move_on_after` and `cancel_after` without block

## 0.33 2020-03-08

- Implement `Fiber#supervise` (WIP)
- Add `Fiber#restart` API
- Fix race condition in `Thread#join`, `Thread#raise` (#14)
- Add `Exception#source_fiber` - references the fiber in which an uncaught
  exception occurred

## 0.32 2020-02-29

- Accept optional throttling rate in `#spin_loop`
- Remove CancelScope
- Allow spinning fibers from a parent fiber other than the current
- Add `#receive_pending` global API.
- Prevent race condition in `Gyro::Queue`.
- Improve signal handling - `INT`, `TERM` signals are now always handled in the
  main fiber
- Fix adapter requires (redis and postgres)

## 0.31 2020-02-20

- Fix signal handling race condition (#13)
- Move adapter code into polyphony/adapters
- Fix spin_loop caller, add tag parameter

## 0.30 2020-02-04

- Add support for awaiting a fiber from multiple monitor fibers at once
- Implemented child fibers
- Fix TERM and INT signal handling (#11)
- Fix compiling on Linux
- Do not reset runnable value in Gyro_suspend (prevents interrupting timers)
- Don't snooze when stopping a fiber
- Fix IO#read for files larger than 8KB (#10)
- Fix fiber messaging in main fiber
- Prevent signalling of inactive async watcher
- Better fiber messaging

## 0.29 2020-02-02

- Pass SignalException to main fiber
- Add (restore) default thread pool
- Prevent race condition in Thread#join
- Add support for cross-thread fiber scheduling
- Remove `#defer` global method
- Prevent starvation of waiting fibers when using snooze (#7)
- Improve tracing
- Fix IRB adapter

## 0.28 2020-01-27

- Accept block in Supervisor#initialize
- Refactor `ThreadPool`
- Implement fiber switch events for `TracePoint`
- Add optional tag parameter to #spin
- Correctly increment ref count for indefinite sleep
- Add `irb` adapter
- Add support for listen/notify to postgres adapter
- Use `:waiting`, `:runnable`, `:running`, `:dead` for fiber states
- Move docs to https://digital-fabric.github.io/polyphony/

## 0.27 2020-01-19

- Reimplement `Throttler` using recurring timer
- Add `Gyro::Selector` for wrapping libev
- Add `Gyro::Queue`, a fiber-aware thread-safe queue
- Implement multithreaded fiber scheduling

## 0.26 2020-01-12

- Optimize `IO#read_watcher`, `IO#write_watcher`
- Implement `Fiber#raise`
- Fix `Kernel#gets` with `ARGV`
- Return `[pid, exit_status]` from `Gyro::Child#await`

## 0.25 2020-01-10

- Fold `Coprocess` functionality into `Fiber`
- Add support for indefinite `#sleep`

## 0.24 2020-01-08

- Extract HTTP code into separate polyphony-http gem
- Cull core, io examples
- Remove `SIGINT` handler

## 0.23 2020-01-07

- Remove `API#pulse`
- Better repeat timer, reimplement `API#every`
- Move global API methods to separate module, include in `Object` instead of
  `Kernel`
- Improve setting root fiber and corresponding coprocess
- Fix `ResourcePool#preheat!`
- Rename `$Coprocess#list` to `Coprocess#map`
- Fix `CancelScope#on_cancel`, remove `CancelScope#protect`
- Remove `auto_run` mechanism. Just use `suspend`!
- Optional coverage report for tests
- More tests
- Add `Coprocess.select` and `Supervisor#select` methods
- Add `Coprocess.join` alias to `Coprocess.await` method
- Add support for cancelling multiple coprocesses with a single cancel scope
- Fix stopping a coprocess before it being scheduled for the first time
- Rewrite `thread`, `thread_pool` modules
- Add `Kernel#orig_sleep` alias to sync `#sleep` method
- Add optional resume value to `Gyro::Async#signal!`
- Patch Fiber#inspect to show correct block location
- Add Gyro.run
- Move away from callback-based API for `Gyro::Timer`, `Gyro::Signal`

## 0.22 2020-01-02

- Redesign Gyro scheduling subsystem, go scheduler-less
- More docs
- Rewrite HTTP client agent c1b63787
- Increment Gyro refcount in ResourcePool#acquire
- Rewrite ResourcePool
- Fix socket extensions
- Fix ALPN setup in Net.secure_socket

## 0.21 2019-12-12

- Add Coprocess.await (for waiting for multiple coprocesses)
- Add Coprocess#caller, Coprocess#location methods
- Remove callback-oriented Gyro APIs
- Revise signal handling API
- Improve error handling in HTTP/2 adapter
- More documentation

## 0.20 2019-11-27

- Refactor and improve CancelScope, ResourcePool
- Reimplement cancel_after, move_on_after using plain timers
- Use Timer#await instead of Timer#start in Pulser
- Rename Fiber.main to Fiber.root
- Replace use of defer with proper fiber scheduling
- Improve Coprocess resume, interrupt, cancel methods
- Cleanup code using Rubocop
- Update and cleanup examples
- Remove fiber pool
- Rename `CoprocessInterrupt` to `Interrupt`
- Fix ResourcePool, Mutex, Thread, ThreadPool
- Fix coprocess message passing behaviour
- Add HTTP::Request#consume API
- Use bundler 2.x
- Remove separate parse loop fiber in HTTP 1, HTTP 2 adapters
- Fix handling of exceptions in coprocesses
- Implement synthetic, sanitized exception backtrace showing control flow across
  fibers
- Fix channels
- Fix HTTP1 connection shutdown and error states
- Workaround for IO#read without length
- Rename `next_tick` to `defer`
- Fix race condition in firing of deferred items, use linked list instead of
  array for deferred items
- Rename `EV` module to `Gyro`
- Keep track of main fiber when forking
- Add `<<` alias for `send_chunk` in HTTP::Request
- Implement Socket#accept in C
- Better conformance of rack adapter to rack spec (WIP)
- Fix HTTP1 adapter
- Better support for debugging with ruby-debug-ide (WIP)

## 0.19 2019-06-12

- Rewrite HTTP server for better concurrency, sequential API
- Support 204 no-content response in HTTP 1
- Add optional count parameter to Kernel#throttled_loop for finite looping
- Implement Fiber#safe_transfer in C
- Optimize Kernel#next_tick implementation using ev_idle instead of ev_timer

## 0.18 2019-06-08

- Rename Kernel#coproc to Kernel#spin
- Rewrite Supervisor#spin

## 0.17 2019-05-24

- Implement IO#read_watcher, IO#write_watcher in C for better performance
- Implement nonblocking (yielding) versions of Kernel#system, IO.popen,
  Process.detach, IO#gets IO#puts, other IO singleton methods
- Add Coprocess#join as alias to Coprocess#await
- Rename Kernel#spawn to Kernel#coproc
- Fix encoding of strings read with IO#read, IO#readpartial
- Fix non-blocking behaviour of IO#read, IO#readpartial, IO#write

## 0.16 2019-05-22

- Reorganize and refactor code
- Allow opening secure socket without OpenSSL context

## 0.15 2019-05-20

- Optimize `#next_tick` callback (about 6% faster than before)
- Fix IO#<< to return self
- Refactor HTTP code and examples
- Fix race condition in `Supervisor#stop!`
- Add `Kernel#snooze` method (`EV.snooze` will be deprecated eventually)

## 0.14 2019-05-17

- Use chunked encoding in HTTP 1 response
- Rewrite `IO#read`, `#readpartial`, `#write` in C (about 30% performance
  improvement)
- Add method delegation to `ResourcePool`
- Optimize PG::Connection#async_exec
- Fix `Coprocess#cancel!`
- Preliminary support for websocket (see `examples/io/http_ws_server.rb`)
- Rename `Coroutine` to `Coprocess`

## 0.13 2019-01-05

- Rename Rubato to Polyphony (I know, this is getting silly...)

## 0.12 2019-01-01

- Add Coroutine#resume
- Improve startup time
- Accept rate: or interval: arguments for throttle
- Set correct backtrace for errors
- Improve handling of uncaught raised errors
- Implement HTTP 1.1/2 client agent with connection management

## 0.11 2018-12-27

- Move reactor loop to secondary fiber, allow blocking operations on main
  fiber.
- Example implementation of erlang-style generic server pattern (implement async
  API to a coroutine)
- Implement coroutine mailboxes, Coroutine#<<, Coroutine#receive, Kernel.receive
  for message passing
- Add Coroutine.current for getting current coroutine

## 0.10 2018-11-20

- Rewrite Rubato core for simpler code and better performance
- Implement EV.snooze (sleep until next tick)
- Coroutine encapsulates a task spawned on a separate fiber
- Supervisor supervises multiple coroutines
- CancelScope used to cancel an ongoing task (usually with a timeout)
- Rate throttling
- Implement async SSL server

## 0.9 2018-11-14

- Rename Nuclear to Rubato

## 0.8 2018-10-04

- Replace nio4r with in-house extension based on libev, with better API,
  better performance, support for IO, timer, signal and async watchers
- Fix mem leak coming from nio4r (probably related to code in Selector#select)

## 0.7 2018-09-13

- Implement resource pool
- transaction method for pg cient
- Async connect for pg client
- Add testing module for testing async code
- Improve HTTP server performance
- Proper promise chaining

## 0.6 2018-09-11

- Add http, redis, pg dependencies
- Move ALPN code inside net module

## 0.4 2018-09-10

- Code refactored and reogranized
- Fix recursion in next_tick
- HTTP 2 server with support for ALPN protocol negotiation and HTTP upgrade
- OpenSSL server

## 0.3 2018-09-06

- Event reactor
- Timers
- Promises
- async/await syntax for promises
- IO and read/write stream
- TCP server/client
- Promised threads
- HTTP server
- Redis interface
- PostgreSQL interface