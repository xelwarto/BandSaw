module BandSaw
   class Event

      attr_reader :id, :msg, :data

      def initialize
         @id = BandSaw::Util.get_rand_id
         @msg = String.new
         @data = Hash.new
      end

      def set_msg(msg_in)
         if msg_in
            @msg = msg_in
         end
      end 

      def set_data(data_in)
         if data_in
            @data = data_in
         end
      end 
   end
end
