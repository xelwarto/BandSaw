module BandSaw
   class App

      def self.run(app_dir)
         @cons = BandSaw::Constants.instance
         @argvs = BandSaw::Util.get_argvs
         @config = BandSaw::Config.instance
         @log = BandSaw::Log.instance

         @log.set_quiet if @argvs["-q"] && !@argvs["-h"]
         @log.set_quiet if @argvs["-d"] && !@argvs["-h"]
         @log.set_debug if @argvs["-D"]
         
         @log.show(BandSaw::Util.show_banner)

         if @argvs["-h"]
            @log.show(BandSaw::Util.show_use)
            exit 0
         end

         @log.info("Starting Application...")

         begin
            @log.debug("locating configuration file")
            cfg_file = find_cfg(app_dir)
            @log.debug("loading configuration file")
            @config.load_config(cfg_file)

            @config.params[:quiet] = true if @argvs["-q"]
            @config.params[:debug] = true if @argvs["-D"]
            @config.params[:daemon] = true if @argvs["-d"]
         rescue Exception => e
            @log.fatal(e)
            exit 1
         end

         if @config.params[:daemon]
            pid = fork
            if pid
               # SET PID HERE
            else
               start 
            end
         else
            start
         end
      end

      def self.start
         @event_q = Queue.new

         start_workers
         start_server
      end

      def self.start_server
         begin
            @log.debug("starting server thread")
            server = BandSaw::Server.new
            server.start(@event_q)
         rescue Exception => e
            @log.fatal(e)
         end
      end

      def self.start_workers
         worker = BandSaw::Worker.new
         if worker
            workers = @cons.workers
            if @config.params[:general][:workers]
               workers = @config.params[:general][:workers]
            end

            if workers
               begin
                  @log.debug("starting #{workers} worker thread(s)")
                  workers = workers.to_i
                  workers.times do |x|
                     worker.start(x.to_s, @event_q)
                  end
               rescue Exception => e
                  @log.error(e)
               end
            end
         end
      end

      def self.find_cfg(app_dir)
         cfg_file = ""

         if @argvs["-c"]
            cfg_file = @argvs["-c"]
         else
            if app_dir && app_dir != ""
               if @cons.cfg_file && @cons.cfg_dir
                  cfg_file = "#{app_dir}/#{@cons.cfg_dir}/#{@cons.cfg_file}"
               end
            end
         end

         if cfg_file != "" && File.exists?(cfg_file)   
            cfg_file
         else
            raise "unable to locate configuration file (#{cfg_file})"
         end
      end
   end
end

# vi:tabstop=3:expandtab:ai
