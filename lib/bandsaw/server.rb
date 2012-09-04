module BandSaw
   class Server

      def initialize
         @cons = BandSaw::Constants.instance
         @config = BandSaw::Config.instance
         @log = BandSaw::Log.instance

         @bind = ""
         @port = ""
      end

      def start(event_q)
         if event_q
            find_port
            @log.debug("found server port: #{@port}")
            find_bind
            @log.debug("found server bind address: #{@bind}")

            if @port && @port != ""
               if @bind && @bind != ""
                  @log.debug("opening TCP connection")
                  server = TCPServer.open(@bind, @port.to_i)

                  @log.debug("entering server loop")
                  while true
                     client = server.accept
                     @log.debug("received client connection")

                     Thread.start(client) do |clnt|
                        handle_client(clnt, event_q)
                     end
                  end
               else
                  raise "unable to set server bind address"
               end
            else
               raise "unable to set server port"
            end
         end
      end

      def handle_client(clnt, event_q)
         @log.debug("starting client handler thread")

         while true
            input = clnt.gets.chop
            break if !input
            event_q.enq(input)
         end

         clnt.close

         @log.debug("ending client handler thread")
      end

      def find_bind
         @bind = @cons.bind
         if @config.params[:general][:bind]
            @bind = @config.params[:general][:bind]
         end
      end

      def find_port
         @port = @cons.port
         if @config.params[:general][:port]
            @port = @config.params[:general][:port]
         end
      end
   end
end

# vi:tabstop=3:expandtab:ai
