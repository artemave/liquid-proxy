require 'socket'

module Utils
  class PortExplorer
    def self.port_occupied?(port)
      !!Net::HTTP.get('127.0.0.1', '/', port)
    rescue => e
      !e.is_a?(Errno::ECONNREFUSED)
    else
      true
    end
  end
end
