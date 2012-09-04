module BandSaw
   class App

      def self.run(app_dir)
         argvs = BandSaw::Util.get_argvs
BandSaw::Util.show_banner
         @config = BandSaw::Config.instance
      end
   end
end
