require 'singleton'
require 'liquid-proxy/service'
require 'json'
require 'rest-client'

class LiquidProxy
  include Singleton

  class HeadersToInject
    def []=(key, value)
      RestClient.post "localhost:#{LiquidProxy.port}", {key => value}.to_json
    end

    def clear
      RestClient.delete "localhost:#{LiquidProxy.port}"
    end
  end

  attr_reader :port

  def headers_to_inject
    @headers_to_inject ||= HeadersToInject.new
  end

  def headers_to_inject=(hash = {})
    @headers_to_inject.clear
    hash.each_pair do |k,v|
      @headers_to_inject[k] = v
    end
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
