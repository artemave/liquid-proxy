require 'singleton'

class LiquidProxy
  class Service
    include Singleton

    def start(opts = {})
    end

    def up?
      true
    end

    def self.method_missing(*args)
      instance.send(*args)
    end
  end
end
