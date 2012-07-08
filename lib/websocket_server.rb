class WebsocketServer
  cattr_accessor :sockets
  cattr_accessor :current_entry

  def self.start(event)
    self.current_entry = ::Entry.new(event)
    self.send_all self.current_entry.to_json
  end

  def self.send_all(*args)
    self.sockets.each do |socket|
      socket.send(*args)
    end
  end

  def initialize
    Thread.new do
      EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 3030) do |ws|
        ws.onopen do
          ::WebsocketServer.sockets << ws
        end
      end
    end
  end
end
