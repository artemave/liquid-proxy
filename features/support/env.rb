$: << File.expand_path("../../../lib", __FILE__)
require 'liquid-proxy'
require 'net/http'
require 'childprocess'
require 'awesome_print'
require 'json'

TEST_APP_SERVER_PORT=8999

def start_test_appserver
  appserver = ChildProcess.build(File.expand_path("../bin/appserver", __FILE__), TEST_APP_SERVER_PORT.to_s)
  appserver.io.inherit!
  appserver.start

  while true
    begin
      Net::HTTP.get "localhost", '/', TEST_APP_SERVER_PORT
      break
    rescue Errno::ECONNREFUSED
      puts "Waiting for test appserver to start..."
      sleep 0.5
    end
  end

  def self.up?
    RestClient.get server_address
  rescue => e
    !e.is_a?(Errno::ECONNREFUSED)
  end
  at_exit do
    appserver.stop
  end
end

start_test_appserver
