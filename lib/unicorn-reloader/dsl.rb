module Unicorn
  module Reloader
    class DSL
      attr_reader :options

      def initialize
        @options = {
          folders: []
        }
      end

      def graceful(value)
        raise TypeError, 'Graceful must be a bool' unless !!value == value
        @options[:graceful] = value
      end

      def poll(value)
        raise TypeError, 'Poll must be a bool' unless !!value == value
        @options[:poll] = value
      end

      def watch_folder(dir)
        if dir.is_a?(Array)
          @options[:folders].concat dir
        else
          @options[:folders] << dir
        end
      end

      def extensions(ext)
        @options[:extensions] = ext
      end
    end
  end
end
