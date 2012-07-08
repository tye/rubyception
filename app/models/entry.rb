class Entry
  attr_accessor :controller
  attr_accessor :action
  attr_accessor :path
  attr_accessor :method
  attr_accessor :format
  attr_accessor :exception
  attr_accessor :duration
  attr_accessor :id

  def initialize(event)
    ::Rails.logger.info "Start With #{event.inspect}"
    payload = event.payload

    self.controller = payload[:controller]
    self.action = payload[:action]
    self.path = payload[:path]
    self.method = payload[:method]
    self.format = payload[:format]
    self.exception = payload[:exception].present?
    self.duration = payload[:duration]
    self.id = payload[:transaction_id]
    self.params = payload[:params]

    @lines = []
  end

  def <<(line)
    ::Rails.logger.info line.inspect
    @lines << line
  end

  def finalize(event)
    ::Rails.logger.info "Finalize with #{event.inspect}"
    flush!
  end

  def to_json
    methods = [:controller, :action, :path, :method, :format,
               :exception, :duration, :id]
    result = {}
    methods.each do |method|
      result[method] = self.send(method)
    end
    {event: result}.to_json
  end

  def flush!
    ::WebsocketServer.send_all to_json
  end
end
