class Entry
  attr_accessor :controller
  attr_accessor :action
  attr_accessor :path
  attr_accessor :method
  attr_accessor :format
  attr_accessor :error
  attr_accessor :duration
  attr_accessor :id
  attr_accessor :params
  attr_accessor :backtrace
  attr_accessor :finished

  def initialize(event)
    set_values event
    @lines = []
  end

  def set_values event
    payload = event.payload
    self.controller = payload[:controller].gsub(/Controller$/,'')
    self.action     = payload[:action]
    self.path       = payload[:path]
    self.method     = payload[:method]
    self.format     = payload[:format]
    self.error  = payload[:exception].present?
    self.duration   = event.duration
    self.id         = event.transaction_id
    self.params     = payload[:params]
  end

  def error?; error; end

  def <<(event)
    @lines << Line.new(event)
  end

  def exception(exception)
    self.backtrace = {
      name: exception.class.name,
      message: exception.message,
      lines: exception.backtrace }
    flush!
  end

  def finalize(event)
    set_values(event)
    self.finished = true
    flush! unless error?
  end

  def to_json
    methods = [:controller, :action, :path, :method, :format,
               :error, :duration, :id, :backtrace, :finished]
    result = {}
    methods.each do |method|
      result[method] = self.send(method)
    end

    result = {event: result, lines: @lines}

    result.to_json
  end

  def flush!
    ::WebsocketServer.send_all to_json
  end
end
