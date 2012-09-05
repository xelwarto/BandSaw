module BandSaw
   class Event

   def initialize
      @worker_id = ""
      @event_msg = ""
      @event_id = ""
      @event_match = false
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

   def set_event(id)
      if id
         @event_id = id
      end
   end

   def get_event
      @event_id
   end

   def matched?
      @event_match
   end

   def set_match
      @event_match = true
   end

   end
end
