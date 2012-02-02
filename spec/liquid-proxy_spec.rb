require_relative "spec_helper"

describe LiquidProxy do
  before do
    LiquidProxy::Service.reset_instance
  end

  it 'starts' do
    LiquidProxy::Service.stub(:up?).and_return(true)
    LiquidProxy::Service.should_receive(:start).with(:port => 1234, :host => 'google.com')

    LiquidProxy.start(:port => 1234, :host => 'google.com')
  end

  context 'when starting' do
    it 'waits for proxy service to come up' do
      LiquidProxy::Service.stub(:up?).and_return(false, false, true)
      Kernel.should_receive(:sleep).with(0.5).twice

      LiquidProxy.start
    end
  end
end
