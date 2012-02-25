require 'childprocess'

class LiquidProxy
  class Subprocess
    def initialize(opts = {})
      @child = ChildProcess.build(File.expand_path("../../../bin/liquid-proxy", __FILE__), opts[:port].to_s || "8998")
      @child.io.inherit!
      @child.start

      at_exit do
        # I don't know why, but without this puts() at_exit is triggered on Ctrl-C when running in spork
        # even though Subprocess has been started in prefork
        puts ''
        @child.stop
      end
    end

    def alive?
      @child.alive?
    end
  end
end
