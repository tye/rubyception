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
      EventMachine::WebSocket.start(options) do |ws|
        puts ws.inspect
        ws.onopen do
          ws.send "Hello Client"
          Rubyception::WebsocketServer.sockets << ws
        end
      end
    end
  end
end
