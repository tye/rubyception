require 'websocket_server'
WebsocketServer.sockets = []
::Rails.logger.auto_flushing = true
puts WebsocketServer.new.inspect
require 'subscriber'
::Rubyception::Subscriber.attach_to :action_controller
::Rubyception::Subscriber.attach_to :action_view

require 'catcher'
::ActionDispatch::DebugExceptions.send(:include,ExceptionsCatcher)
