require 'em-websocket'

class Rubyception::WebsocketServer
  cattr_accessor :sockets
  cattr_accessor :current_entry

  def self.start(event)
    self.current_entry = Rubyception::Entry.new(event)
    self.send_all self.current_entry.to_json
  end

  def self.send_all(*args)
    self.sockets.each do |socket|
      socket.send(*args)
    end
  end

  def initialize
    Thread.new do
      options = { 
        host: '0.0.0.0',
        port: 3030 }
      while defined?(Thin) && !EventMachine.reactor_running?
        sleep 1
      end
      EventMachine::WebSocket.start(options) do |ws|
        ws.onopen do
          Rubyception::WebsocketServer.sockets << ws
        end
      end
    end
  end
end
