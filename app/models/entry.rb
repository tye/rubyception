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
  attr_accessor :start_time
  attr_accessor :end_time

  def initialize(event)
    set_values event
    @lines = []
  end

  def set_values event
    payload = event.payload
    self.controller = payload[:controller].gsub(/Controller$/,'').downcase.underscore
    self.action     = payload[:action]
    self.path       = payload[:path]
    self.method     = payload[:method]
    self.format     = payload[:format]
    self.error      = payload[:exception].present?
    self.duration   = event.duration
    self.id         = event.transaction_id
    self.params     = payload[:params]
    self.start_time = event.time.to_s(:entry)
    self.end_time   = event.end.to_s(:entry)
  end

  def error?; error; end

  def <<(event)
    @lines << Line.new(event)
  end

  def exception(exception)

    lines = exception.backtrace
    lines = lines.collect{|l|{msg:l}}

    self.backtrace = {
      name:    exception.class.name,
      message: exception.message,
      lines:   lines }
    flush!
  end

  def finalize(event)
    set_values(event)
    self.finished = true
    flush! unless error?
  end

  def to_json
    methods = [:controller, :action, :path, :method, :format,
               :error, :duration, :id, :backtrace, :finished,
               :start_time, :end_time]
    result = {}
    methods.each do |method|
      result[method] = self.send(method)
    end

    result = result.merge(lines: @lines)

    result.to_json
  end

  def flush!
    ::WebsocketServer.send_all to_json
  end
end
