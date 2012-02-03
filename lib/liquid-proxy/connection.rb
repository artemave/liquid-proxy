require 'liquid-proxy/request_processor'

class LiquidProxy::Connection
  def self.setup(conn, request_processor = RequestProcessor.new(conn))
    conn.on_data do |data|
      request_processor << data
    end
  end
end
