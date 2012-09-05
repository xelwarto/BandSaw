#!/usr/bin/env ruby

exe_dir =  File.dirname(File.expand_path($0))

$:.push "#{exe_dir}/lib"
require 'socket'
require 'thread'
require 'mx'
require 'yaml'

def handle_client(c)
   puts "THREAD START"
   while true
      input = c.gets.chop
      break if !input
      @q.enq(input)
   end
   c.close
   puts "THREAD END"
end

def main
   server = TCPServer.open("127.0.0.1", 8100)
   @q = Queue.new

   Thread.new do
      puts "Starting Thread 1"
      while true
         i = @q.deq
         puts "T1: #{i}"
      end
   end

   Thread.new do
      puts "Starting Thread 2"
      while true
         i = @q.deq
         puts "T2: #{i}"
      end
   end

   while true
      client = server.accept
puts client.class
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

@args = Mx::Util.get
if @args["-d"] || @args["--daemon"]
   pid = fork
   if pid
      puts "Child pid #{pid}"
   else
      main
   end
elsif @args["-h"]
   showUsage
else
   main
end

# vi:tabstop=3:expandtab:ai
