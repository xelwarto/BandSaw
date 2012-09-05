module BandSaw
   class Event

   def initialize
      @worker_id = ""
      @event_msg = ""
   end

   def set_msg(msg)
      if msg
         @event_msg = msg
      end
   end

   def get_msg
      @event_msg
   end

   def set_worker(id)
      if id
         @worker_id = id
      end
   end

   def get_worker
      @worker_id
   end

   end
end
