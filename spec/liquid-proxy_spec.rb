require_relative "spec_helper"
require 'liquid-proxy'

describe LiquidProxy do
  before do
    LiquidProxy::Service.reset_instance
    LiquidProxy.reset_instance
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
    let :headers_to_inject do
      double('headers_to_inject')
    end

    before do
      LiquidProxy::HeadersToInject.stub(:new).and_return(headers_to_inject)
    end

    it 'allows specify header as hash key' do
      headers_to_inject.should_receive(:[]=).with('X_HACK', 'KABOOM')
      LiquidProxy.headers_to_inject['X_HACK'] = 'KABOOM'
    end

    it 'allows specify headers by assigning hash' do
      headers_to_inject.should_receive(:set_hash).with('X_HACK' => 'KABOOM')
      LiquidProxy.headers_to_inject = {'X_HACK' => 'KABOOM'}
    end

    it 'clears off list headers to inject' do
      headers_to_inject.should_receive(:clear)
      LiquidProxy.headers_to_inject.clear
    end
  end
end
