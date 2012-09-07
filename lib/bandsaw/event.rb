module BandSaw
   class Event

      attr_reader :worker, :msg, :type, :data

      def initialize
         @worker = String.new
         @msg = String.new
         @type = String.new
         @data = Hash.new
      end

      def set_msg(msg_in)
         if msg_in
            @msg = msg_in
         end
      end 

      def set_worker(id_in)
         if id_in
            @worker = id_in
         end
      end 

      def set_type(type_in)
         if type_in
            @type = type_in
         end
      end 

      def set_data(data_in)
         if data_in
            @data = data_in
         end
      end 
   end
end
