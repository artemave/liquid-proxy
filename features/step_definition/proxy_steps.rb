Given /^liquid-proxy is running$/ do
  LiquidProxy.start
end

When /^I instruct liquid\-proxy to add header "([^"]*)" with value "([^"]*)"$/ do |header, value|
  LiquidProxy.headers_to_inject[header] = value
end

When /^an http client makes request to a server via liquid-proxy$/ do
  proxy_class = Net::HTTP::Proxy('localhost', LiquidProxy.port)
  res = proxy_class.start("localhost", TEST_APP_SERVER_PORT) do |http|
    http.get "/something"
  end
  @request = JSON.parse(res.body)
end

Then /^that server should see header "([^"]*)" with value "([^"]*)" in incoming requests$/ do |header, value|
  @request["HTTP_#{header}"].should == value
end
