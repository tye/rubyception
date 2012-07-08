class Line
  attr_accessor :event
  attr_accessor :params
  attr_accessor :duration

  def initialize(event)
    self.event    = event.name
    self.params   = event.payload
    self.duration = event.duration
  end

  def to_json
    {
      event:    event,
      params:   params,
      duration: duration
    }.to_json
  end
end
