#!/usr/bin/env ruby

exe_dir =  File.dirname(File.expand_path($0))

$:.push "#{exe_dir}/lib"
require 'mx'

@config = Mx::Config.instance
@config.load_config("test.cfg")

puts @config.params[:general][:bind]

@config.params[:alerts].each do |a, b|
   puts b[:email]
end

# vi:tabstop=3:expandtab:ai
