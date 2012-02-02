require 'singleton'

class LiquidProxy
  include Singleton

  def headers_to_inject
    {}
  end

  def port
  end

  def host
  end

  def self.method_missing(*args)
    instance.send(*args)
  end
end
