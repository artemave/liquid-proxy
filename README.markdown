# Liquid Proxy

[![Build status](https://secure.travis-ci.org/artemave/liquid-proxy.png)](https://secure.travis-ci.org/artemave/liquid-proxy)

## Overview

Start an http proxy that you can later control via api to inject http headers into requests passing through.
Why? I needed it to recreate parts of infrustructure in test environment (namely, the app I am testing is behind the proxy that takes care of authenticating users and passes on its checks in the form of http header).

## Usage

This is a ruby gem and it requires ruby >= 1.9.2

    bash$ gem install liquid-proxy # or, better, use Gemfile
    
The following example shows usage with cucumber/selenium. First in env.rb:

    require 'capybara'
    require 'selenium-webdriver'
    require 'liquid-proxy'
    
    LiquidProxy.start(:port => 9889) 
        
    Capybara.register_driver :selenium do |app|
      profile = Selenium::WebDriver::Firefox::Profile.new
      profile.proxy = Selenium::WebDriver::Proxy.new(http: 'localhost:9889', type: :manual)

      Capybara::Selenium::Driver.new(app, :profile => profile)
    end
    
Then in you steps:
    
