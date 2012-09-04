#!/usr/bin/env ruby

bin_path = String.new
bin_dir = String.new
app_dir = String.new

bin_path = File.expand_path($0)
if bin_path && bin_path != ""
   bin_dir = File.dirname(bin_path)
end

if bin_dir && bin_dir != ""
   app_dir = "#{bin_dir}/.."
   $:.push "#{app_dir}/lib"
else
   puts "Error: unable to locate bin directory"
   exit 1
end

require 'bandsaw'
BandSaw::App.run(app_dir)

exit 0

# vi:tabstop=3:expandtab:ai
