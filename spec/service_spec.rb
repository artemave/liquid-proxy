require_relative 'spec_helper'
require_relative 'support/port_explorer'
require 'liquid-proxy/service'

describe LiquidProxy::Service do
  context 'when started' do
    it 'starts subprocess' do
      opts = {:host => 'localhost'}

      LiquidProxy::Subprocess.should_receive(:new).with(opts)
      LiquidProxy::Service.start(opts)
    end

    it 'does nothing if subprocess already running' do
      LiquidProxy::Subprocess.should_receive(:new).once.and_return(stub(:alive? => true))
      
      LiquidProxy::Service.start
      LiquidProxy::Service.start
    end
  end

  it 'knows when it is up'
end
