module BandSaw
   class Util
      ID_CHARS = ('0'..'9').to_a
      DEF_ID_LEN = 20

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

      def self.get_rand_id(len=DEF_ID_LEN)
         begin
            len = DEF_ID_LEN if ! len.instance_of? Fixnum
            self.gen_rand_id(Array.new(len, ''), ID_CHARS)
         rescue => e
            raise "#{e.message}"
         end
      end

      private

      def self.gen_rand_id(a, chars)
         raise ArgumentError, "invalid argument (a)" if ! a.instance_of? Array
         raise ArgumentError, "invalid argument (chars)" if ! chars.instance_of? Array
         a.collect { chars[rand(chars.size)] }.join
      end
 
   end
end

# vi:tabstop=3:expandtab:ai
