module Rubyception::ExceptionsCatcher
  def self.included base
    base.send :alias_method_chain,
              :render_exception,
              :rubyception
  end

  def render_exception_with_rubyception env, exception
    if Rubyception::WebsocketServer.current_entry
      Rubyception::WebsocketServer.current_entry.exception exception
    end
    render_exception_without_rubyception env, exception
  end
end
