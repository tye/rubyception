require 'websocket_server'
WebsocketServer.sockets = []
::Rails.logger.auto_flushing = true
WebsocketServer.new

require 'subscriber'
attach_to = [
  :action_controller,
  :action_view,
  :active_record,
  :action_mailer
]
attach_to.each do |notification|
  ::Rubyception::Subscriber.attach_to notification
end

require 'catcher'
::ActionDispatch::DebugExceptions.send(:include,ExceptionsCatcher)
