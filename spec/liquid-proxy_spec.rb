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
      Kernel.should_receive(:sleep).with(0.5).exactly(3).times

      LiquidProxy.start
    end
  end

  context 'header injection' do
    it 'allows specify header as hash key' do
      RestClient.should_receive(:post).with("localhost:#{LiquidProxy.port}", {'X_HACK' => 'KABOOM'}.to_json)
      LiquidProxy.headers_to_inject['X_HACK'] = 'KABOOM'
    end

    it 'allows specify headers by assigning hash' do
      RestClient.should_receive(:delete).with("localhost:#{LiquidProxy.port}").ordered
      RestClient.should_receive(:post).with("localhost:#{LiquidProxy.port}", {'X_HACK' => 'KABOOM'}.to_json).ordered

      LiquidProxy.headers_to_inject = {'X_HACK' => 'KABOOM'}
    end

    it 'cal clear off headers to inject' do
      RestClient.should_receive(:delete).with("localhost:#{LiquidProxy.port}")
      LiquidProxy.headers_to_inject.clear
    end
  end
end
