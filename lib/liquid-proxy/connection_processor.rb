require 'http/parser'
require 'liquid-proxy/server_relay'
require 'liquid-proxy/request_builder'
require 'liquid-proxy/api_controller'

class LiquidProxy
  module ConnectionProcessor
    include ServerRelay
    include ApiController

    def process_data(data)
      parser << data
    end

    def parser
      @parser ||= Http::Parser.new(self)
    end

    def body
      @body ||= ''
    end

    def on_body(chunk)
      body << chunk
    end

    def request_builder
      @request_builder ||= RequestBuilder.new
    end

    def on_message_complete
      if api_call?
        process_api_call
      else
        parser.headers.merge!(headers_to_inject)

        new_request = request_builder.build(parser, body)
        body.clear
        pass_to_server new_request
      end
    end

    def headers_to_inject
      @headers_to_inject ||= {}
    end
  end
end
