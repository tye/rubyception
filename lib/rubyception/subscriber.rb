class Rubyception::Subscriber < ActiveSupport::LogSubscriber
  INTERNAL_PARAMS = %w(controller action format _method only_path)

  # ActionController

  def initialize
    @@event = nil
    @@queued_line = []
    super
  end

  def start_processing(event)
    @@event = Rubyception::Entry.new(event)
    if @@queued_line.any?
      @@queued_line.each { |l| @@event << l }
      @@queued_line = []
    end
  end

  def process_action(event)
    @@event.finalize event
    Rubyception::Queue.add @@event
    @@event = nil
  end

  methods = %i(halted_callback redirect_to send_file send_data
               unpermitted_parameters deep_munge write_fragment
               read_fragment exist_fragment? expire_fragment
               expire_page write_page) # action_controller
  methods += %i(render_template render_partial render_collection) # action_view
  methods += %i(sql) # active_record
  methods += %i(deliver receive) # action_mailer

  # http://edgeguides.rubyonrails.org/active_support_instrumentation.html#render_partial-
  #methods.concat([
    #:render_template, # identifier (template name)             , layout
    #:render_partial , # identifier
    #:sql            , # sql (the query)                        , name (ie SELECT, DELETE ...)
    #:deliver        , # mailer (Mailer class)                  , message_id     , subject    , to, from, bcc, cc, date, mail (message contents)
    #:redirect_to    , # status (http status)                   , location
    #:halted_callback, # filter (method name where chain halted)
  #])
  methods.each do |name|
    class_eval <<-METHOD, __FILE__, __LINE__ + 1
      def #{name}(event)
        unless @@event
          @@queued_line << event
        else
          @@event << event
        end
      end
    METHOD
  end
end
