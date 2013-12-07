require_relative "spec_helper"
require 'liquid-proxy/connection'
require 'liquid-proxy/connection_processor'

describe LiquidProxy::Connection do
  context "em-proxy connection setup" do
    it 'feeds data to connection processor' do
      conn = double
      conn.should_receive(:extend).with(LiquidProxy::ConnectionProcessor) # this assert stinks?
      conn.should_receive(:on_data) do |&block|
        conn.should_receive(:process_data).with("data")
        block.call("data")
      end
      LiquidProxy::Connection.setup(conn)
    end
  end
end
