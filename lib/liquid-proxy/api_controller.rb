require 'json'
require 'http_tools'

class LiquidProxy
  module ApiController
    def process_api_call
      if parser.http_method =~ /delete/i
        headers_to_inject.clear
      else
        new_headers = JSON.parse(body) rescue {}
        headers_to_inject.merge!(new_headers)
      end

      send_data HTTPTools::Builder.response(:ok)
      close_connection_after_writing
    end

    def api_call?
      host, port = parser.headers['Host'].split(':')
      host =~ /^(localhost|127.0.0.1)$/ && port == ::LIQUID_PROXY_PORT.to_s
    end
  end
end
