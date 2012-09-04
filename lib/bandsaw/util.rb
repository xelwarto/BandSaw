module BandSaw
   class Util

      def self.get_argvs
         argvs = Hash.new
         cur_argvs = String.new

         if ARGV.length > 0
            ARGV.each do |x|
               if x =~ /^-/
                  cur_argvs = x
                  argvs[cur_argvs] = 1
               else
                  if cur_argvs != ""
                     argvs[cur_argvs] = x
                     cur_argvs = ""
                  end
               end
            end
         end
         argvs
      end

      def self.show_banner
         banner = <<EOF
______                 _ _____                
| ___ \\               | /  ___|               
| |_/ / __ _ _ __   __| \\ `--.  __ ___      __
| ___ \\/ _` | '_ \\ / _` |`--. \\/ _` \\ \\ /\\ / /
| |_/ / (_| | | | | (_| /\\__/ / (_| |\\ V  V / 
\\____/ \\__,_|_| |_|\\__,_\\____/ \\__,_| \\_/\\_/  

EOF
         puts banner
      end

   end
end
