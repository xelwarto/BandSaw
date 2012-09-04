module BandSaw
   class Constants
      include Singleton

      attr_reader :version, :author, :cfg_file, :cfg_dir, :workers, :bind, :port

      def initialize
         @version = "0.1"
         @author = "Ted Elwartowski (09/2012)"

         @cfg_file = "bandsaw.cfg"
         @cfg_dir = "conf"

         @workers = 5
         @bind = "127.0.0.1"
         @port = 8105
      end
   end
end

# vi:tabstop=3:expandtab:ai
