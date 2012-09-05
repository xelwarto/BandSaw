module BandSaw
   class Log
      include Singleton

      def initialize
         @log_file = ""
         @is_quiet = false
         @is_debug = false
      end

      def show(msg)
         if msg
            puts msg unless @is_quiet
         end
      end

      def info(msg)
         if msg
            msg = "INFO: #{msg}"
            puts msg unless @is_quiet
         end
      end

      def debug(msg)
         if msg && @is_debug
            msg = "DEBUG: #{msg}"
            puts msg unless @is_quiet
         end
      end

      def error(msg)
         if msg
            msg = "Error: #{msg}"
            puts msg unless @is_quiet
         end
      end

      def fatal(msg)
         if msg
            msg = "Error: #{msg}"
            puts msg
         end
      end

      def set_log_file(file)
         @log_file
      end

      def set_quiet
         @is_quiet = true
      end

      def set_debug
         @is_debug = true
      end
   end
end

# vi:tabstop=3:expandtab:ai
