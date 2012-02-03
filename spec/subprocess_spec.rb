require 'tempfile'
require_relative 'spec_helper'
require 'liquid-proxy/subprocess'

describe LiquidProxy::Subprocess do
  let :child do
    double.as_null_object
  end

  before do
    ChildProcess.stub(:build).and_return(child)
  end

  context 'ChildProcess start' do
    it 'builds ChildProcess with cmd args from opts' do
      opts = {:port => 1234}
      ChildProcess.should_receive(:build) do |cmd, *params|
        cmd.should =~ %r{bin/liquid-proxy}
        params.should == ["1234"]
      end
      LiquidProxy::Subprocess.new(opts)
    end
    it 'inherits io and then starts child' do
      child.should_receive(:io).ordered.and_return(io = mock)
      io.should_receive(:inherit!)
      child.should_receive(:start).ordered
      LiquidProxy::Subprocess.new
    end
  end

  it 'knows if it is alive' do
    child.stub(:alive? => true)
    p = LiquidProxy::Subprocess.new
    p.alive?.should == true
  end

  it 'makes sure ChildProcess does not outlive parent' do
    res_file = Tempfile.new('res')
    child.stub(:stop) do
      res_file.write "stopped"
      res_file.rewind
    end
    fork do
      LiquidProxy::Subprocess.new
    end
    Process.wait
    res_file.read.should == 'stopped'
  end
end
