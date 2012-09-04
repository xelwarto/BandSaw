module BandSaw
   class Worker

      def initialize
         @cons = BandSaw::Constants.instance
         @config = BandSaw::Config.instance
         @log = BandSaw::Log.instance

         @worker_q = Queue.new
      end

      def start(id)
         Thread.new(id) do |i|
            @log.debug("starting worker thread #{i.to_s}")
            while true
               msg = @worker_q.deq
               if msg
                  puts "Worker#{i.to_s}: #{msg.to_s}"
               end
            end
         end
      end
   end
end
