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
                        begin
                           handle_client(clnt, event_q)
                        rescue Exception => e
                           @log.fatal(e)
                        end
                     end
                  end
               else
                  raise "unable to set server bind address"
               end
            else
               raise "unable to set server port"
            end
         else
            raise "event queue not available"
         end
      end

      def handle_client(clnt, event_q)
         @log.debug("starting client handler thread")
         if clnt && !clnt.closed?
            if event_q
               while true
                  input = clnt.gets
                  break if !input

                  if input
                     input = input.chop

                      event = BandSaw::Event.new
                      event.set_msg(input.to_s)
                      event_q.enq(event)
                  end
               end
               clnt.close
            else
               raise "event queue not available"
            end
         else
            raise "client connection not available"
         end

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
