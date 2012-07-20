class Rubyception::Entry
  attr_accessor :controller,
                :action,
                :path,
                :method,
                :format,
                :error,
                :duration,
                :id,
                :params,
                :backtrace,
                :finished,
                :start_time,
                :end_time

  def initialize(event)
    set_values event
    @lines = []
  end

  def set_values event
    payload         = event.payload
    self.controller = payload[:controller].gsub(/Controller$/,'').downcase.underscore
    self.action     = payload[:action]
    self.path       = payload[:path]
    self.method     = payload[:method]
    self.format     = payload[:format]
    self.error      = payload[:exception].present?
    self.duration   = event.duration.to_f.round(2)
    self.id         = event.transaction_id
    self.params     = payload[:params]
    self.start_time = event.time.to_s :entry
    self.end_time   = event.end.to_s  :entry
  end

  def error?; error; end

  def <<(event)
    @lines << Rubyception::Line.new(event).attrs unless ignore_event?(event)
  end

  def ignore_event?(event)
    payload = event.payload
    case
    when event.name == 'sql.active_record' && payload[:name] == 'SCHEMA'
      # SCHEMA sql are things like SHOW TABLES, DESCRIBE USERS
      true
    else
      false
    end
  end

  def exception(exception)
    lines = exception.backtrace
    x = 0
    lines = lines.collect do |l|
      parts = l.match(%r{^(#{Regexp.quote(::Rails.root.to_s)})?(.*):(\d+):in `(.*?)'$})
      x += 1
      {
        num:      x,
        msg:      parts[2],
        app_path: parts[1],
        line_num: parts[3],
        in:       parts[4]
      }
    end

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
    methods = %w{controller
                 action
                 path
                 method
                 format
                 error
                 duration
                 id
                 backtrace
                 finished
                 start_time
                 end_time}
    result = {}
    methods.each do |method|
      method         = method.to_sym
      result[method] = self.send method
    end
    result = result.merge lines: @lines
    result.to_json
  end

  def flush!
    Rubyception::WebsocketServer.send_all to_json
  end
end
