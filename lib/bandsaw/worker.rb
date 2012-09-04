module BandSaw
   class Worker

      def initialize
         @cons = BandSaw::Constants.instance
         @config = BandSaw::Config.instance
         @log = BandSaw::Log.instance
      end

      def start(id, event_q)
         if id && event_q
            Thread.new(id) do |i|
               @log.debug("starting worker thread #{i.to_s}")
               while true
                  msg = event_q.deq
                  if msg
                     puts "Worker#{i.to_s}: #{msg.to_s}"
                  end
               end
            end
         else
            raise "unable to start worker thread (#{id})"
         end
      end
   end
end

# vi:tabstop=3:expandtab:ai
