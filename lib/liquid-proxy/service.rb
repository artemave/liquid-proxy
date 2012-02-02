require 'singleton'
require 'liquid-proxy/cmd_args_builder'
require 'liquid-proxy/subprocess'

class LiquidProxy
  class Service
    include Singleton

    def start(opts = {})
      if @child and @child.alive?
        return
      end

      @child = Subprocess.new(opts)
    end

    def up?
      true
    end

    def self.method_missing(*args)
      instance.send(*args)
    end
  end
end
