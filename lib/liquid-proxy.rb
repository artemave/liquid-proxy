require 'singleton'
require 'liquid-proxy/service'

class LiquidProxy
  include Singleton

  attr_reader :port

  def headers_to_inject
    {}
  end

  def start(opts = {:port => 8998})
    @port = opts[:port]

    Service.start(opts)

    while not Service.up?
      Kernel.sleep 0.5
    end
  end

  def self.method_missing(*args)
    instance.send(*args)
  end
end
