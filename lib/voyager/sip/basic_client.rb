require 'socket'

# Rudimentary SIP Client

module Voyager
  module SIP
    module BasicSipClient
      VERBOSE = true
      TIMESTAMP_FORMAT = "%Y%m%d    %H%M%S"
      @socket

      def initialize(host, port)
        Rails::logger.info "SIPClient: Connecting with #{host}:#{port}" if VERBOSE
        @socket = TCPSocket::new(host, port)

        if block_given?
          begin
            yield self
          ensure
            # When given a socket, we automatically close connection
            close
          end
        end
      end

      def send(msg)
        Rails::logger.info "SIPClient: Sending #{msg}" if VERBOSE
        @socket.write("#{msg.strip}\r")

        # If a block is given, yield the response
        if block_given?
          yield recv
        end
      end

      def recv
        msg = ""
        until msg =~ /\r/
          result = IO::select([@socket], nil, nil)

          for inp in result[0]
            msg << @socket.recv(300);
          end
        end

        Rails::logger.info "SIPClient: Recieved #{msg.strip}" if VERBOSE
        msg
      end

      def close
        Rails::logger.info "SIPClient: Connection closed." if VERBOSE
        @socket.close
      end

      def timestamp
        Time.now.strftime(TIMESTAMP_FORMAT)
      end
    end
  end
end
