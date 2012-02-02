require_relative "spec_helper"

describe LiquidProxy do
  before do
    LiquidProxy::Subprocess.reset_instance
  end

  it 'starts' do
    LiquidProxy.start(:port => 1234, :host => 'google.com')
    LiquidProxy::Subprocess.should_receive(:start).with(:port => 1234, :host => 'google.com')
  end
end
