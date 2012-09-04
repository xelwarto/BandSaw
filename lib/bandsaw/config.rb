module BandSaw
   class Config
      include Singleton

      attr_reader :params, :configured

      def initialize
         @configured = false
      end

      def load_config(cfg_file)
         if !@configured
            load(cfg_file)
         end
      end

      def force_load(cfg_file)
         load(cfg_file)
      end

      def load(file)
         @configured = false

         if File.exists?(file) && File.file?(file) && File.readable?(file)
            @params = Hash.new
            cur_sec = String.new
            cur_sub = String.new

            IO.foreach(file) do |line|
               line.chop

               next if line =~ /^$/
               next if line =~ /^#/

               if line =~ /^\[(.*)?\]$/
                  if $1
                     cur_sec = $1
                     cur_sub = ""

                     if !@params[cur_sec.to_sym]
                        @params[cur_sec.to_sym] = Hash.new
                     end
                  end
               elsif line =~ /^\[(.*)?\]\((.*)?\)$/
                  if $1 && $2
                     cur_sec = $2
                     cur_sub = $1

                     if @params[cur_sec.to_sym]
                        if !@params[cur_sec.to_sym][cur_sub.to_sym]
                           @params[cur_sec.to_sym][cur_sub.to_sym] = Hash.new
                        end
                     end
                  end
               else
                  (name, value) = line.split(/\s*\=\s*/, 2)

                  if name && value
                     if cur_sec && cur_sec != ""
                        if cur_sub && cur_sub != ""
                           if @params[cur_sec.to_sym][cur_sub.to_sym]
                              @params[cur_sec.to_sym][cur_sub.to_sym][name.to_sym] = value
                           end
                        else
                           if @params[cur_sec.to_sym]
                              @params[cur_sec.to_sym][name.to_sym] = value
                           end
                        end
                     end
                  end
               end
            end

            if @params[:general]
               @configured = true
            else
               raise "unable to verify configuration file (#{file})"
            end
         else
            raise "unable to access configuration file (#{file})"
         end
      end
   end
end

# vi:tabstop=3:expandtab:ai
