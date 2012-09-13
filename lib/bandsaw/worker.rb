module BandSaw
   class Worker

      def initialize
         @cons = BandSaw::Constants.instance
         @config = BandSaw::Config.instance
         @log = BandSaw::Log.instance

         @event_log = Hash.new
         @lock = Mutex.new
      end

      def init_event_log
         @log.debug("initializing event log")
         if @config.params[:events] 
            @config.params[:events].each do |e_id, e_data|
               if e_data && e_data[:match] && e_data[:type]
                  if !@event_log[e_id]
                     @log.debug("creating new event log for: #{e_id}")
                     e_log = BandSaw::EventLog.new
                     e_log.set_id(e_id)
                     e_log.set_data(e_data)
                     @event_log[e_id] = e_log
                  end
               end
            end
         else
            @log.fatal("unable to locate events in configuration")
            return false
         end
         return true
      end

      def start(id, event_q)
         if id
            if event_q
               Thread.new(id) do |i|
                  begin
                     @log.debug("starting worker thread #{i.to_s}")
                     while true
                        msg = event_q.deq
                        @log.debug("worker #{i} found new message in queue")

                        if msg
                           @log.debug("worker #{i} creating new event for message")
                           event = BandSaw::Event.new
                           event.set_msg(msg)

                           @log.info("worker #{i} created event: #{event.id}")

                           do_work(event)
                        else
                           @log.error("worker #{i} unable to process message")
                        end
                     end
                  rescue Exception => e
                     @log.fatal("thread execution: #{e.message}")
                  end
               end
            else
               raise "worker event queue not available"
            end
         else
            raise "unable to start worker thread (#{id})"
         end
      end

      def do_work(event)
         if event && event.id
            @log.debug("starting work on event: #{event.id}")

            event.set_data(parse_msg(event))
            if event.data
               eval_event(event) 
            else
               @log.error("data not found for event: #{event.id}")
            end
         else
            @log.error("worker unable to locate event")
         end         
      end

      def eval_event(event)
         if event && event.data
            @log.debug("evaluating data for event: #{event.id}")

            if event.data["@type"]
               @log.debug("found type \"#{event.data['@type']}\" for event: #{event.id}")
               if @config.params[:events] 
                  @config.params[:events].each do |e_id, e_data|
                     if e_data && e_data[:match] && e_data[:type]
                        if event.data["@type"] == e_data[:type]
                           regex_opt = false
                           if e_data[:ignoreCase] && e_data[:ignoreCase] =~ /true/i
                              regex_opt = true
                           end

                           regex = Regexp.new(Regexp.escape(e_data[:match]), regex_opt)
                           msg = event.data["@message"]

                           if regex.match(msg)
                              @log.info("event #{event.id} matched configured event: #{e_id}")

                              if @event_log[e_id]
                                 @lock.synchronize {
                                    @event_log[e_id].add_count
                                    @event_log[e_id].add_alert
                                    @log.debug("event log: #{e_id} ~ count = #{@event_log[e_id].count}")
                                    @log.debug("event log: #{e_id} ~ alerts = #{@event_log[e_id].alerts}")
   
                                    if e_data[:delay]
                                       if @event_log[e_id].count >= e_data[:delay].to_i
                                          if e_data[:retry]
                                             if @event_log[e_id].count == @event_log[e_id].alerts
                                                if @event_log[e_id].alert_hit
                                                   @event_log[e_id].clear_alert_hit
                                                else
                                                   @log.info("sending alert for event: #{event.id} (#{e_id})")
                                                   send_alert(event, @event_log[e_id])
                                                   @event_log[e_id].clear_alerts
                                                   @event_log[e_id].add_alert_hit
                                                end
                                             else
                                                if @event_log[e_id].alerts >= e_data[:retry].to_i
                                                   @log.info("sending alert for event: #{event.id} (#{e_id})")
                                                   send_alert(event, @event_log[e_id])
                                                   @event_log[e_id].clear_alerts
                                                   @event_log[e_id].add_alert_hit
                                                end
                                             end
                                          else
                                             @log.info("sending alert for event: #{event.id} (#{e_id})")
                                             send_alert(event, @event_log[e_id])
                                          end
   
                                          @event_log[e_id].clear_count
                                       end
                                    else
                                       send_alert(event, @event_log[e_id])
                                    end 
                                 }
                              end 
                           end
                        end
                     end
                  end
               else
                  @log.error("unable to locate events from configuration")
               end
            else
               @log.error("worker unable to locate event type")
            end
         else
            @log.error("worker unable to eval event data")
         end
      end

      def parse_msg(event)
         if event
            @log.debug("parsing message for event: #{event.id}")
            if event.msg && event.msg != ""
               begin
                  JSON.parse(event.msg)
               rescue Exception => e
                  @log.fatal("JSON parse error for event: #{event.id} ~ #{e}")
               end
            else
               @log.error("unable to parse message for event: #{event.id}")
            end
         else
            @log.error("worker unable to parse event data")
         end
      end

      def send_alert(event, event_log)
         if event
            if event_log
               notify = event_log.data[:notify]
               if notify && notify != ""
                  n_list = Array.new
                  @log.debug("found event notify list: #{notify}")
                  if notify =~ /\,/
                     n_list = notify.split /\,/
                  else
                     n_list.push notify
                  end

                  to_list = Array.new
                  n_list.each do |n|
                     if @config.params[:emails][n.to_sym]
                        if @config.params[:emails][n.to_sym][:email]
                           @log.debug("found email list: #{@config.params[:emails][n.to_sym][:email]}")
                           if @config.params[:emails][n.to_sym][:email] =~ /\,/
                              to_list = @config.params[:emails][n.to_sym][:email].split /\,/
                           else
                              to_list.push @config.params[:emails][n.to_sym][:email]
                           end
                        end
                     end
                  end

                  if to_list.size > 0
                     sub = @cons.alert_sub
                     if event_log.data[:subject]
                        sub = "#{sub} #{event_log.data[:subject]} (#{event_log.id})"
                     else
                        sub = "#{sub} #{event_log.id}"
                     end

                     data = ""
                     begin
                        send = BandSaw::SendMsg.new
                        send.set_subject(sub)
                        send.set_body(data)
                        send.set_server(@config.params[:general][:smtp][:server]) if @config.params[:general][:smtp][:server]
                        send.set_port(@config.params[:general][:smtp][:port]) if @config.params[:general][:smtp][:port]
                        send.set_from(@config.params[:general][:smtp][:from]) if @config.params[:general][:smtp][:from]
                        send.set_to(to_list)
                        send.send
                     rescue Exception => e
                        @log.error("unable to send alert: #{e.message}")
                     end 
                  end
               else
                  @log.error("unable to locate event notify list")
               end
            else
               @log.error("worker unable to send event alert")
            end
         else
            @log.error("worker unable to send event alert")
         end
      end
   end
end

# vi:tabstop=3:expandtab:ai
