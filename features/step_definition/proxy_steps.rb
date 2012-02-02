Given /^I have http client using liquid\-proxy$/ do
end

When /^I instruct liquid\-proxy to add header "([^"]*)" with value "([^"]*)"$/ do |header, value|
  LiquidProxy.headers_to_inject[header] = value
end

When /^the client makes http request to a server$/ do
  proxy_class = Net::HTTP::Proxy(LiquidProxy.host, LiquidProxy.port)
  res = proxy_class.start("localhost", TEST_APP_SERVER_PORT) do |http|
    http.get "/"
  end
  @request = JSON.parse(res.body)
end

Then /^that server should see header "([^"]*)" with value "([^"]*)" in incoming requests$/ do |header, value|
  @request["HTTP_#{header}"].should == value
end
