require 'singleton'

class LiquidProxy
  class Subprocess
    include Singleton

    def start(opts = {})
      puts "HERE"
    end

    def self.method_missing(*args)
      instance.send(*args)
    end
  end
end
