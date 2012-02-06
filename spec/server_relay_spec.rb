require_relative "spec_helper"
require 'liquid-proxy/server_relay'

describe LiquidProxy::ServerRelay do
  let :conn do
    Object.new.extend(LiquidProxy::ServerRelay)
  end

  it 'relays to server usging host and port from incoming request' do
    host, port = 'remotehost', 9876
    conn.stub(:parser => stub(:headers => {'Host' => "#{host}:#{port}"}))

    conn.should_receive(:server).with(anything, :host => host, :port => port).ordered
    conn.should_receive(:relay_to_servers).with('new_request').ordered

    conn.pass_to_server('new_request')
  end

  it 'uses port 80 by default' do
    conn.stub(:relay_to_servers => nil, :parser => stub(:headers => {'Host' => "localhost"}))

    conn.should_receive(:server).with(anything, :host => 'localhost', :port => 80)

    conn.pass_to_server('new_request')
  end
end
