require_relative "spec_helper"
require 'liquid-proxy/connection'

describe LiquidProxy::Connection do
  context "em-proxy connection setup" do
    it 'feeds data to request processor' do
      conn, request_processor = mock, mock

      conn.should_receive(:on_data) do |&block|
        request_processor.should_receive(:<<).with("data")
        block.call("data")
      end
      LiquidProxy::Connection.setup(conn, request_processor)
    end
  end
end
