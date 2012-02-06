require_relative "spec_helper"
require 'liquid-proxy/connection_processor'
require 'liquid-proxy/server_relay'
require 'liquid-proxy/api_controller'

describe LiquidProxy::ConnectionProcessor do
  let :conn do
    o = Object.new
    o.extend(LiquidProxy::ConnectionProcessor)
    o.extend(LiquidProxy::ServerRelay)
    o.extend(LiquidProxy::ApiController)
    o
  end

  it 'feeds connection data to parser' do
    data = 'data'
    Http::Parser.stub(:new).and_return(parser = mock)
    parser.should_receive(:<<).with(data)
    conn.process_data(data)
  end

  it 'passes request through' do
    new_request = "new_request#{Time.now}"
    parser = stub(:headers => {'Host' => 'localhost'})
    conn.stub(:body => (body = mock), :parser => parser, :request_builder => (request_builder = stub))
    request_builder.stub(:build).with(conn.parser, conn.body).and_return(new_request)

    body.should_receive(:clear)
    conn.should_receive(:pass_to_server).with(new_request)

    conn.on_message_complete
  end

  it 'adds custom headers to requests passing through' do
    headers_to_inject = {'blah' => 'val1', 'boom' => 'val2'}

    conn.stub(:server => nil, :relay_to_servers => nil)
    conn.stub(:headers_to_inject => headers_to_inject)
    conn.parser.stub(:headers).and_return(headers = mock.as_null_object)

    headers.should_receive(:merge!).with(headers_to_inject)

    conn.on_message_complete
  end

  it 'treats requests to itself as API calls' do
    conn.stub(:server => nil, :relay_to_servers => nil)
    conn.stub(:api_call? => true)

    conn.should_receive(:process_api_call)
    conn.should_not_receive(:pass_to_server)
    conn.on_message_complete
  end
end
