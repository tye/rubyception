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
		params          = payload[:params]
		params.delete 'controller'
		params.delete 'action'
    self.params     = params
    self.start_time = event.time.strftime('%H:%M:%S')
    self.end_time   = event.end.strftime('%H:%M:%S')
  end


  def parsed_params
    result = {}
    jsonified = params.collect do |key,val|
      [key, val.to_json]
    end
    Hash[jsonified]
  end

  def deep_clone_hash hash
    result = {}
    hash.each do |k,v|
      if v.is_a? Hash
        result[k] = deep_clone_hash v
      else
        result[k] = v
      end
    end
    result
  end

  def parsed_nested_params params=nil
    params ||= deep_clone_hash(self.params)
    if params.kind_of? Hash
      params.each do |key,val|
        params[key] = parsed_nested_params(params[key])
      end
    else
      return params.inspect
    end
    params
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
      parts = l.match(%r{^(#{Regexp.quote(::Rails.root.to_s)}/)?(.*):(\d+):in `(.*?)'$})
      next unless parts
      x += 1
      {
        num:      x,
        msg:      parts[2],
        app_path: parts[1],
        line_num: parts[3],
        in:       parts[4],
        url:      CGI.escape("file://#{parts[1]}#{parts[2]}"),
        rails:    !parts[1]
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
								 params
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
                 parsed_params
                 parsed_nested_params
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
