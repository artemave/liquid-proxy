require_relative 'spec_helper'
require 'utils/port_explorer'
require 'liquid-proxy/service'

describe LiquidProxy::Service do
  before do
    LiquidProxy::Service.reset_instance
  end

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

  it 'knows when it is up if subprocess is alive and service port is occupied' do
    port = 1234
    LiquidProxy::Subprocess.stub(:new).and_return(sp = stub(:alive? => true))

    sp.should_receive(:alive?)
    Utils::PortExplorer.should_receive(:port_occupied?).with(port).and_return(true)

    LiquidProxy::Service.start(:port => port)
    LiquidProxy::Service.up?.should == true
  end

  context 'it knows that it is NOT up' do
    it 'if it has not been started' do
      LiquidProxy::Service.up?.should == false
    end

    it 'if subprocess is not alive' do
      LiquidProxy::Subprocess.stub(:new).and_return(sp = stub(:alive? => false))

      sp.should_receive(:alive?)
      LiquidProxy::Service.start
      LiquidProxy::Service.up?.should == false
    end

    it 'if service port is not occupied' do
      port = 1234
      LiquidProxy::Subprocess.stub(:new).and_return(sp = stub(:alive? => true))

      sp.should_receive(:alive?)
      Utils::PortExplorer.should_receive(:port_occupied?).with(port).and_return(false)
      
      LiquidProxy::Service.start(:port => port)
      LiquidProxy::Service.up?.should == false
    end
  end

end
