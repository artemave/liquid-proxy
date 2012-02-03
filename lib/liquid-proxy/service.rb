require 'singleton'
require 'liquid-proxy/subprocess'
require 'utils/port_explorer'

class LiquidProxy
  class Service
    include Singleton

    def start(opts = {})
      if @child and @child.alive?
        return
      end

      @port = opts[:port]

      @child = Subprocess.new(opts)
    end

    def up?
      !!(@child && @child.alive? && Utils::PortExplorer.port_occupied?(@port))
    end

    def self.method_missing(*args)
      instance.send(*args)
    end
  end
end
