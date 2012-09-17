module BandSaw
   class MsgBuilder

      attr_reader :msg_subject, :msg_to, :msg_from, :smtp_server, :smtp_port, :msg_data

      def initialize(event, event_log)
         @event = event
         @event_log = event_log

         @cons = BandSaw::Constants.instance
         @config = BandSaw::Config.instance
         @log = BandSaw::Log.instance

         @msg_subject = @cons.smtp_subject
         @msg_from = @cons.smtp_from
         @smtp_server = @cons.smtp_server
         @smtp_port = @cons.smtp_port
         @msg_to = Array.new
         @msg_data = String.new

         find_msg_info
      end

      def find_msg_info
         if @config.params[:general][:smtp]
            if @config.params[:general][:smtp][:from]
               @msg_from = @config.params[:general][:smtp][:from]
            end

            if @config.params[:general][:smtp][:server]
               @msg_server = @config.params[:general][:smtp][:server]
            end

            if @config.params[:general][:smtp][:port]
               @msg_port = @config.params[:general][:smtp][:port]
            end

            if @config.params[:general][:smtp][:subject]
               @msg_subject = @config.params[:general][:smtp][:subject]
            end
         end

         if @event_log.data[:subject]
            @msg_subject = "#{@msg_subject} #{@event_log.data[:subject]} (#{@event_log.id})"
         else
            @msg_subject = "#{@msg_subject} #{@event_log.id}"
         end

         notify = String.new
         notify = @event_log.data[:notify] if @event_log.data[:notify]
         if notify && notify != ""
            n_list = Array.new
            @log.debug("found event notify list: #{notify}")

            if notify =~ /\,/
               n_list = notify.split /\,/
            else
               n_list.push notify
            end

            n_list.each do |n|
               if @config.params[:emails][n.to_sym]
                  if @config.params[:emails][n.to_sym][:email]
                     @log.debug("found email list: #{@config.params[:emails][n.to_sym][:email]}")
                     if @config.params[:emails][n.to_sym][:email] =~ /\,/
######### FIX HERE ###############
                        @msg_to = @config.params[:emails][n.to_sym][:email].split /\,/
##################################
                     else
                        @msg_to.push @config.params[:emails][n.to_sym][:email]
                     end
                  end
               end
            end
         else
            @log.error("unable to locate event notify list")
         end 
      end

   end
end
