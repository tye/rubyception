class Rubyception::Subscriber < ActiveSupport::LogSubscriber
  INTERNAL_PARAMS = %w(controller action format _method only_path)

  # ActionController

  def start_processing(event)
    Rubyception::WebsocketServer.start event
  end

  def process_action(event)
    Rubyception::WebsocketServer.current_entry.finalize event
  end

  # http://edgeguides.rubyonrails.org/active_support_instrumentation.html#render_partial-
  [
    :render_template, # identifier (template name)             , layout
    :render_partial , # identifier
    :sql            , # sql (the query)                        , name (ie SELECT, DELETE ...)
    :deliver        , # mailer (Mailer class)                  , message_id     , subject    , to, from, bcc, cc, date, mail (message contents)
    :redirect_to    , # status (http status)                   , location
    :halted_callback, # filter (method name where chain halted)

  ].each do |name|
    class_eval <<-METHOD, __FILE__, __LINE__ + 1
      def #{name}(event)
        Rubyception::WebsocketServer.current_entry << event
      end
    METHOD
  end
end
