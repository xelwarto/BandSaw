module BandSaw
   class EventLog

      attr_reader :id, :count

      def initialize
         @id = String.new
         @count = 0
      end
   end
end
