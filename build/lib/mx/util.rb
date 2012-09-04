module Mx
   class Util

      def self.get
         @args = Hash.new
         cur_args = String.new

         if ARGV.length > 0
            ARGV.each do |x|
               if x =~ /^-/
                  cur_args = x
                  @args[cur_args] = 1
               else
                  if cur_args != ""
                     @args[cur_args] = x
                     cur_args = ""
                  end
               end
            end
         end
         @args
      end

   end
end
# vi:tabstop=3:expandtab:ai
