require 'singleton'
require 'liquid-proxy/service'
require 'json'
require 'net/http'

class LiquidProxy
  include Singleton

  class HeadersToInject
    def []=(key, value)
      http.post '/', {key => value}.to_json
    end

    def set_hash(hash = {})
      clear
      http.post '/', hash.to_json unless hash.empty?
    end

    def clear
      http.delete '/'
    end

    private

      def http
        @http ||= Net::HTTP.new('127.0.0.1', LiquidProxy.port)
      end
  end

  attr_reader :port

  def headers_to_inject
    @headers_to_inject ||= HeadersToInject.new
  end

  def headers_to_inject=(hash = {})
    headers_to_inject.set_hash(hash)
  end

  def start(opts = {:port => 8998})
    @port = opts[:port]

    Service.start(opts)

    Kernel.sleep 0.5
    while not Service.up?
      puts "Waiting for LiquidProxy to start..."
      Kernel.sleep 0.5
    end
  end

  def self.method_missing(*args)
    instance.send(*args)
  end
end
