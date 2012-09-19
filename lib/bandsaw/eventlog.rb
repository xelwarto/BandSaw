module BandSaw
   class EventLog

      attr_reader :id, :data, :count, :alerts, :alert_hit, :last_alert, :full_count

      def initialize
         @id = String.new
         @data = Hash.new
         @count = 0
         @alerts = 0
         @full_count = 0
         @alert_hit = false
         @last_alert = 0
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
         @full_count = @full_count + 1
         update_time
      end

      def add_alert
         @alerts = @alerts + 1
         update_time
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

      def update_time
         time_now = Time.now
         @last_alert = time_now.to_i
      end

      def clear_all
         @count = 0
         @full_count = 0
         @alerts = 0
         @last_alert = 0
      end
   end
end
