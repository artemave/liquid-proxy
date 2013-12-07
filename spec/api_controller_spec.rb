require_relative "spec_helper"
require 'liquid-proxy/api_controller'

describe LiquidProxy::ApiController do
  let :conn do
    o = Object.new
    o.extend(LiquidProxy::ApiController)
    o
  end

  it 'knows when request is an api call' do
    LIQUID_PROXY_PORT = 9876 unless defined?(LIQUID_PROXY_PORT)

    conn.stub_chain('parser.headers').and_return('Host' => "localhost:#{LIQUID_PROXY_PORT}")
    conn.api_call?.should == true
  end

  it 'knows when request is NOT an api call' do
    conn.stub_chain('parser.headers').and_return('Host' => "localhost:1111")
    conn.api_call?.should == false
  end

  it 'adds headers to inject' do
    new_headers = {'X_HACK' => 'Boom'}
    conn.stub(:send_data => nil, :close_connection_after_writing => nil, :parser => double.as_null_object)
    conn.stub(:body => new_headers.to_json)
    conn.stub(:headers_to_inject => (headers_to_inject = double))

    headers_to_inject.should_receive(:merge!).with(new_headers)
    conn.process_api_call
  end

  it 'clears off headers to inject if api request method is DELETE' do
    conn.stub(:send_data => nil, :close_connection_after_writing => nil)
    conn.stub_chain('parser.http_method').and_return('DELETE')
    conn.stub(:headers_to_inject => (headers_to_inject = double))
    headers_to_inject.should_receive(:clear)
    conn.process_api_call
  end

  it 'relays back to client' do
    response = "response_#{Time.now}"
    HTTPTools::Builder.stub(:response).with(:ok).and_return(response)
    conn.stub(:headers_to_inject => double.as_null_object, :parser => double.as_null_object)

    conn.should_receive(:send_data).with(response).ordered
    conn.should_receive(:close_connection_after_writing).ordered

    conn.process_api_call
  end
end
