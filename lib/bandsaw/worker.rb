module BandSaw
   class Worker

      def initialize
         @cons = BandSaw::Constants.instance
         @config = BandSaw::Config.instance
         @log = BandSaw::Log.instance

         @event_log = Hash.new
         @lock = Mutex.new
      end

      def start(id, event_q)
         if id
            if event_q
               Thread.new(id) do |i|
                  begin
                     @log.debug("starting worker thread #{i.to_s}")
                     while true
                        event = event_q.deq
                        if event
                           event.set_worker(i.to_s)
                           do_work(event)
                        else
                           @log.error("worker unable to locate event")
                        end
                     end
                  rescue Exception => e
                     @log.fatal(e)
                  end
               end
            else
               raise "event queue not available"
            end
         else
            raise "unable to start worker thread (#{id})"
         end
      end

      def do_work(event)
         if event && event.msg
            event.set_data(parse_msg(event.msg))
            if event.data
               puts event.data
               if event.data["type"]
                  puts event.data["type"]
                  eval_event(event) 
               end
            else
               raise "event data not found"
            end
         else
            raise "unable to do worker - event not found"
         end         
      end

      def eval_event(event)
         if @config.params[:events] 
            @config.params[:events].each do |e_id, e_data|
               @lock.synchronize {
               }
            end
         else
            raise "unable to locate configured events"
         end
      end

      def parse_msg(msg)
         if msg && msg != ""
            begin
               JSON.parse(msg)
            rescue Exception => e
               @log.fatal(e)
            end
         else
            raise "unable to parse event message"
         end
      end
   end
end

# vi:tabstop=3:expandtab:ai
