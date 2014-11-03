require 'listen'
require 'unicorn-reloader/version'
require 'unicorn-reloader/dsl'

module Unicorn
  module Reloader
    class Runner
      DEFAULT_EXT_PATTERNS = /\.(?:rb|erb|coffee|haml|html|htm|less|js|sass|scss|yml)$/

      def initialize(options = {}, unicorn_args = [])
        @unicorn_args = unicorn_args
        @unicorn_pid = -111111
        @options = {
          poll: false,
          graceful: true,
          folders: [Dir.pwd],
          extensions: DEFAULT_EXT_PATTERNS
        }

        @config_file = DSL.new
        config_file = File.expand_path(File.join(Dir.pwd, "UnicornReloader"))
        if File.exists?(config_file)
          @config_file.instance_eval(File.read(config_file))
        end

        # Merge the config file options and the cmdline options
        @options = @options.merge(@config_file.options).merge(options)

        p @options

        @listener = Listen.to(*@options[:folders], only: @options[:extensions],
            force_polling: @options[:poll]) do |modified, added, removed|

          $stdout.puts "File changes detected: #{ { modified: modified,
            added: added, removed: removed }.inspect }"

          reload!
        end

        setup_signal_listeners
        @listener.start

        start_unicorn

        sleep(99999) while true
      end

      def setup_signal_listeners
        func = lambda do |sig|
          Thread.new { @listener.stop }

          Process.kill(:INT, @unicorn_pid)
          Process.wait(@unicorn_pid)
          exit
        end

        Signal.trap(:INT, &func)
        Signal.trap(:EXIT, &func)
      end

      def reload!
        begin
          Process.getpgid(@unicorn_pid)

          command = @options[:graceful] ? :QUIT : :TERM
          Process.kill(command, @unicorn_pid)
          Process.wait(@unicorn_pid)
        rescue Errno::ESRCH
          $stdout.puts 'Nothing to reload, Unicorn isn\'t running'
        end

        start_unicorn
      end

      def start_unicorn
        $stdout.puts "Starting Unicorn with: #{ @unicorn_args.join(' ') }"
        @unicorn_pid = Kernel.spawn('unicorn', *@unicorn_args)
      end
    end
  end
end
