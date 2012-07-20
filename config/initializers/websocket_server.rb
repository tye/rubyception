require 'rubyception/websocket_server'
require 'rubyception/subscriber'
require 'rubyception/catcher'

::Rails.logger.auto_flushing = true
Rubyception::WebsocketServer.sockets = []
Rubyception::WebsocketServer.new

attach_to = [
  :action_controller,
  :action_view,
  :active_record,
  :action_mailer
]
attach_to.each do |notification|
  Rubyception::Subscriber.attach_to notification
end

if defined? ::ActionDispatch::DebugExceptions
  ::ActionDispatch::DebugExceptions.send(:include,Rubyception::ExceptionsCatcher)
else
  ::ActionDispatch::ShowExceptions.send(:include,Rubyception::ExceptionsCatcher)
end
