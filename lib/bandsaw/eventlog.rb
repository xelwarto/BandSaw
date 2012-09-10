module BandSaw
   class EventLog

      attr_reader :id, :data, :count, :alerts, :alert_hit

      def initialize
         @id = String.new
         @data = Hash.new
         @count = 0
         @alerts = 0
         @alert_hit = false
      end

      def set_id(e_id)
         if e_id
            @id = e_id
         end
      end 

      def set_data(e_data)
         if e_data
            @data = e_data
         end
      end 

      def add_count
         @count = @count + 1
      end

      def add_alert
         @alerts = @alerts + 1
      end

      def add_alert_hit
         @alert_hit = true
      end

      def clear_count
         @count = 0
      end

      def clear_alerts
         @alerts = 0
      end

      def clear_alert_hit
         @alert_hit = false
      end
   end
end
