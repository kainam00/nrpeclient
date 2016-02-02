# Based on the excellent work done here - https://gist.github.com/krobertson/1182622

require 'socket'
require 'openssl'
require_relative 'packet.rb'

class NRPEClient

  def initialize(host, port)
    sock = TCPSocket.new(host, port)
    context = OpenSSL::SSL::SSLContext.new "SSLv23_client"
    context.ciphers = 'ADH'
    @ssl_socket = OpenSSL::SSL::SSLSocket.new(sock, context)
    @ssl_socket.sync_close = true
    @ssl_socket.connect
  end

  def command(command)
    nrpe_packet = Nagios::NrpePacket.new
    nrpe_packet.packet_type = :query
    nrpe_packet.result_code = 0
    nrpe_packet.buffer = "#{command}"
    @ssl_socket.puts(nrpe_packet.to_bytes)
    packet = Nagios::NrpePacket.read @ssl_socket
    return packet
  end

  def parse_output(output)
    return output
  end


  def close
    @ssl_socket.close
  end

end
