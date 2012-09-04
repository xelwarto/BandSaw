module BandSaw
   class Util

      def self.get_argvs
         argvs = Hash.new
         cur_argvs = String.new

         if ARGV.length > 0
            ARGV.each do |x|
               if x =~ /^-/
                  cur_argvs = x
                  argvs[cur_argvs] = ""
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

      def self.show_use
         usage = <<EOF
#{$0} OPTIONS

Options:
	-c <file> Use alternate configuration file
	-d        Run in background as a daemon process
        -D        Turn on debug mode
	-h        This help menu
	-q        Run in quiet mode

EOF
         usage
      end

      def self.show_banner
         cons = BandSaw::Constants.instance
         banner = <<EOF
______                 _ _____                
| ___ \\               | /  ___|               
| |_/ / __ _ _ __   __| \\ `--.  __ ___      __
| ___ \\/ _` | '_ \\ / _` |`--. \\/ _` \\ \\ /\\ / /
| |_/ / (_| | | | | (_| /\\__/ / (_| |\\ V  V / 
\\____/ \\__,_|_| |_|\\__,_\\____/ \\__,_| \\_/\\_/  
Version: #{cons.version}
Written by: #{cons.author}

EOF
         banner
      end

   end
end

# vi:tabstop=3:expandtab:ai
