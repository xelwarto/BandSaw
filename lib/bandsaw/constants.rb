module BandSaw
   class Constants
      include Singleton

      attr_reader :version, :author, :cfg_file, :cfg_dir, :workers, :bind, :port, :smtp_server, :smtp_port, :smtp_subject, :smtp_from, :alert_timeout

      def initialize
         @version = "0.3"
         @author = "Ted Elwartowski (09/2012)"

         @cfg_file = "bandsaw.cfg"
         @cfg_dir = "conf"

         @workers = 5
         @bind = "127.0.0.1"
         @port = 8105

         @smtp_server = "127.0.0.1"
         @smtp_port = "25"
         @smtp_from = "no-reply@gmail.com"
         @smtp_subject = "BandSaw Alert:"

         @alert_timeout = 1800
      end
   end
end

# vi:tabstop=3:expandtab:ai
