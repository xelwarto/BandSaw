module BandSaw
   class Constants
      include Singleton

      attr_reader :version, :author, :cfg_file, :cfg_dir, :workers, :bind, :port, :smtp_server, :smtp_port, :alert_sub

      def initialize
         @version = "0.2"
         @author = "Ted Elwartowski (09/2012)"

         @cfg_file = "bandsaw.cfg"
         @cfg_dir = "conf"

         @workers = 5
         @bind = "127.0.0.1"
         @port = 8105

         @smtp_server = "127.0.0.1"
         @smtp_port = "25"
         @alert_sub = "BandSaw Alert:"
      end
   end
end

# vi:tabstop=3:expandtab:ai
