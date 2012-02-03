require 'childprocess'

class LiquidProxy
  class Subprocess
    def initialize(opts = {})
      @child = ChildProcess.build(File.expand_path("../../../bin/liquid-proxy", __FILE__), opts[:port].to_s || "8998")
      @child.io.inherit!
      @child.start

      at_exit do
        @child.stop
      end
    end

    def alive?
      @child.alive?
    end
  end
end
