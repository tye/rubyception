class WebsocketServer
  @@sockets = []

  def initialize
    Thread.new do
      puts "NEW THREWQ"
      EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 3030) do |ws|
          ws.onopen {
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
            ::Rails.logger.info "[RubyCeption] msg: #{msg}"
          }
      end
    end
  end
end
