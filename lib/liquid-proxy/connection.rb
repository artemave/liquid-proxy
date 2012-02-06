require 'liquid-proxy/connection_processor'

class LiquidProxy
  class Connection
    def self.setup(conn)
      conn.extend(ConnectionProcessor)

      conn.on_data do |data|
        conn.process_data(data)
      end
    end
  end
end
