module BandSaw
   class EventLog

      def initialize
         @event_id = ""
         @event_count = 0
      end

      def set_event(id)
         if id
            @event_id = id
         end
      end

      def get_event
         @event_id
      end

      def add
         @event_count = @event_count + 1
      end

      def get_count
         @event_count
      end

   end
end
