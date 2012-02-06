require_relative "spec_helper"
require 'liquid-proxy/request_builder'

describe LiquidProxy::RequestBuilder do
  it 'builds HTTP request' do
    body = '_with_body'
    parser = stub(:http_method => 'method', :headers => {'Host' => 'host'}, :request_url => 'url')
    HTTPTools::Builder.stub(:request).with('method', 'host', 'url', {'Host' => 'host'}).and_return('new_request')

    LiquidProxy::RequestBuilder.new.build(parser, body).should == 'new_request_with_body'
  end
end
