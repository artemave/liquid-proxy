require 'http_tools'

class LiquidProxy
  class RequestBuilder
    def build(parser, body = '')
      new_request = HTTPTools::Builder.request(
        parser.http_method,
        parser.headers['Host'],
        parser.request_url,
        parser.headers
      )
      new_request+= body
    end
  end
end
