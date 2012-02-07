# Liquid Proxy

[![Build status](https://secure.travis-ci.org/artemave/liquid-proxy.png)](https://secure.travis-ci.org/artemave/liquid-proxy)

## Overview

Start http proxy that you can control via api in order to inject http headers into requests passing through.

Why? I needed it to recreate parts of infrustructure in test environment (namely, the app under test was behind the proxy that takes care of authenticating users and passes on its checks in the form of http header).

## Usage

This is a ruby gem and it requires ruby >= 1.9.2.

```ruby
# Gemfile
gem 'liquid-proxy'
```
    
The following example shows usage with cucumber/capybara/selenium:

```ruby
# env.rb
require 'capybara'
require 'selenium-webdriver'
require 'liquid-proxy'
    
LiquidProxy.start(:port => 9889)
    
Capybara.configure do |config|
  config.default_driver = :selenium
  config.run_server = false
  config.app_host = "http://test.example.com"
end
        
Capybara.register_driver :selenium do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile.proxy = Selenium::WebDriver::Proxy.new(http: 'localhost:9889', type: :manual)

  Capybara::Selenium::Driver.new(app, profile: profile)
end
    
Before do
  LiquidProxy.clear
end
```

Then in step definitions you can:

```ruby
# set headers to inject
LiquidProxy.headers_to_inject = {'Foo' => 'Bar', 'Accept' => 'Cash'}
    
# add to headers to inject
LiquidProxy.headers_to_inject['X_HACKERY'] = 'BOOM'
    
# clear headers to inject
LiquidProxy.clear
```

## Standalone usage

If you are not using ruby, it is possible to run liquid-proxy as a standalone process and controll it via REST api:

    # install
    bash$ gem install liquid-proxy
    
    # start
    bash$ liquid-proxy 8998
    
    # add headers
    bash$ curl --data-binary '{"Foo":"Bar","Accept":"Cash"}' http://localhost:8998
    
    # clear headers
    bash$ curl -X DELETE http://localhost:8998
    

## Author

[Artem Avetisyan](https://github.com/artemave)