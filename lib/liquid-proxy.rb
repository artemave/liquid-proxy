require 'singleton'
require 'liquid-proxy/subprocess'

class LiquidProxy
  include Singleton

  attr_reader :host, :port

  def headers_to_inject
    {}
  end

  def start(opts = {:port => 8998, :host => 'localhost'})
    Subprocess.start(opts)
  end

  def self.method_missing(*args)
    instance.send(*args)
  end
end
