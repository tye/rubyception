module Rubyception
  class Engine < ::Rails::Engine
    isolate_namespace Rubyception
    initializer 'rubyception.start_websocket', :after=> :build_middleware_stack do |app|
      require 'rubyception/websocket_server'
      require 'rubyception/subscriber'
      require 'rubyception/catcher'

      Rubyception::WebsocketServer.sockets = []
      puts "[RUBYCEPTION] Starting Websocket server"
      Rubyception::WebsocketServer.new

      attach_to = [
        :action_controller,
        :action_view,
        :active_record,
        :action_mailer
      ]
      puts "[RUBYCEPTION] Adding notification subscribers"
      attach_to.each do |notification|
        Rubyception::Subscriber.attach_to notification
      end

      puts "[RUBYCEPTION] Adding exception catcher"
      if defined? ::ActionDispatch::DebugExceptions
        ::ActionDispatch::DebugExceptions.send(:include,Rubyception::ExceptionsCatcher)
      else
        ::ActionDispatch::ShowExceptions.send(:include,Rubyception::ExceptionsCatcher)
      end
    end
  end
end
