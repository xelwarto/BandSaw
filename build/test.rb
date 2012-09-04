#!/usr/bin/env ruby

exe_dir =  File.dirname(File.expand_path($0))

$:.push "#{exe_dir}/lib"
require 'socket'
require 'mx'
require 'yaml'


def handle_client(c)
   puts "THREAD START"
   while true
      input = c.gets.chop
      break if !input
      puts input
   end
   c.close
   puts "THREAD END"
end

def main
   server = TCPServer.open(8100)

   while true
      client = server.accept
      puts "CLIENT CONNECTED"
      Thread.start(client) do |c|
         handle_client(c)
      end
   end
end

def showUsage
   use = <<EOF

Usage: app options

Options:
	-d | --daemon Run as background process

EOF

   puts use
end


#@var = Hash[File.read('test.cfg').scan(/(\S+)\s*=\s*"([^"]+)/)]
@var = Hash[File.read('test.cfg')]
@var2 = File.read('test.cfg').scan(/(\S+)\s*=\s*"([^"]+)/)
puts @var2.to_s

@cfg = YAML::load_file("test.cfg")
c = YAML::dump(@cfg)
#puts c

#puts @cfg["p3"]
#puts @cfg["p2"]

@var.each do |p,v|
   puts "HERE #{p} #{v}"
end

@args = Mx::Util.get
if @args["-d"] || @args["--daemon"]
   pid = fork
   if pid
      puts "Child pid #{pid}"
   else
      #main
   end
elsif @args["-h"]
   showUsage
else
   #main
end


# vi:tabstop=3:expandtab:ai
