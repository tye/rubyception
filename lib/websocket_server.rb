class WebsocketServer
  cattr_accessor :sockets
  cattr_accessor :current_entry

  def self.send_all(*args)
    ::Rails.logger.info "Sending: #{args.inspect}"
    ::Rails.logger.info self.sockets.inspect
    self.sockets.each do |socket|
      ::Rails.logger.info "[%] -> #{socket.send(*args).inspect}"
    end
  end

  def initialize
    Thread.new do
      puts "NEW THREAD"
      EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 3030) do |ws|
          ws.onopen {
            puts "SOCKET OPENED"
            ::Rails.logger.info '[%] Opened'
            begin
              ::WebsocketServer.sockets << ws
            rescue Exception => e
              File.open('/Users/tye/test.txt','w'){|f| f.write "#{e.class.name}: #{e.message}" }
            end
          }

          ws.onclose {
          }

          ws.onmessage { |msg|
            STDOUT.puts "FUUUCL: #{msg}"
            ::Rails.logger.info "[RubyCeption] msg: #{msg}"
          }
      end
    end
  end
end
