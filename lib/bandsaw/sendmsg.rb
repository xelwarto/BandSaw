module BandSaw
   class SendMsg

      def initialize
         @cons = BandSaw::Constants.instance
         @config = BandSaw::Config.instance
         @log = BandSaw::Log.instance

         @server = @cons.smtp_server
         @port = @cons.smtp_port
         @from = @cons.smtp_from

         @tos = Array.new
         @data = String.new
      end

      def set_server(s)
         if s
            @server = s
         end
      end

      def set_port(p)
         if p
            @port = p
         end
      end

      def set_from(f)
         if f
            @from = f
         end
      end

      def set_data(d)
         if d
            @data = d
         end
      end

      def add_to(t)
         if t
            @tos.push t
         end
      end

      def set_to(t)
         if t 
            if t.instance_of? Array
               @tos = t
            end
         end
      end

      def send
         raise "from email address not set" unless @from != ""
         raise "to email address(es) not set" unless @tos.size > 0

         smtp = Net::SMTP.new(@server, @port) 
         smtp = Net::SMTP.start("localhost")
         smtp.send_message(@data, @from, @tos)
         smtp.finish
      end
   end
end
