module ExceptionsCatcher
  def self.included(base)
    puts "FUCK"
    base.send(:alias_method_chain,:render_exception,:rubyception)
  end

  def render_exception_with_rubyception(env,exception)
    env['rubyception.exception'] = exception
    ::WebsocketServer.send_all({
      exception: {
        name: exception.class.name,
        message: exception.message,
        backtrace: exception.backtrace}}.
      to_json)
    render_exception_without_rubyception(env,exception)
  end
end
