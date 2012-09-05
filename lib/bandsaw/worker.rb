module BandSaw
   class Worker

      def initialize
         @cons = BandSaw::Constants.instance
         @config = BandSaw::Config.instance
         @log = BandSaw::Log.instance
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
               # ERROR HERE
            end
         else
            raise "unable to start worker thread (#{id})"
         end
      end

      def do_work(event)
         puts "Worker#{event.get_worker}: #{event.get_msg}"
      end
   end
end

# vi:tabstop=3:expandtab:ai
