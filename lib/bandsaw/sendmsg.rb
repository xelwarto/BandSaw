module BandSaw
   class SendMsg

      def initialize
         @cons = BandSaw::Constants.instance
         @config = BandSaw::Config.instance
         @log = BandSaw::Log.instance

         @server = @cons.smtp_server
         @port = @cons.smtp_port
         @tos = Array.new
         @to = Sting.new
         @from = Sting.new
         @subject = Sting.new
         @body = Sting.new
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

      def set_subject(s)
         if s
            @subject = s
         end
      end

      def set_body(b)
         if b
            @body = b
         end
      end

      def add_to(t)
         if t
            @tos.push t
         end
      end

      def set_to(t)
         if t && t.instance_of? Array
            @tos = t
         end
      end

      def send
         raise "from email address not set" unless @from != ""
         raise "to email address not set" unless @tos.size > 0
         raise "subject not set" unless @subject from != ""

         c = 0
         @tos.each do |t|
            if c == 0
               @to = "#{t}"
            else
               @to = "#{@to}, #{t}"
            end
         end

         @data = <<EOF
From: #{@from}
To: #{@to}
Subject: #{@subject}

#{@body}
EOF

         smtp = Net::SMTP.start(@server, @port) 
         smtp.send_message(@data, @from, @tos)
         smtp.finish
      end
   end
end
