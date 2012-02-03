require_relative "spec_helper"
require 'liquid-proxy'

describe LiquidProxy do
  before do
    LiquidProxy::Service.reset_instance
  end

  it 'starts' do
    LiquidProxy::Service.stub(:up?).and_return(true)
    LiquidProxy::Service.should_receive(:start).with(:port => 1234)

    LiquidProxy.start(:port => 1234)
  end

  it 'knows its port' do
    LiquidProxy::Service.stub(:up?).and_return(true)
    LiquidProxy::Service.stub(:start)

    LiquidProxy.start(:port => 1234)
    LiquidProxy.port.should == 1234
  end

  context 'when starting' do
    it 'waits for proxy service to come up' do
      LiquidProxy::Service.stub(:start)
      LiquidProxy::Service.stub(:up?).and_return(false, false, true)
      Kernel.should_receive(:sleep).with(0.5).twice

      LiquidProxy.start
    end
  end
end
