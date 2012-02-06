class LiquidProxy
  module ServerRelay
    def pass_to_server request
      host, port = parser.headers['Host'].split(':')
      server :test, :host => host, :port => (port || 80).to_i
      relay_to_servers request
    end
  end
end
