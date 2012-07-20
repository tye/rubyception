class App.Views.Entries.Entry extends Backbone.View
  className: 'entry'
  events:
    'click': 'select_and_toggle'
  initialize: ->
    @render()
  select_and_toggle: =>
    unless $(@el).hasClass 'selected'
      @index.entry $ @el
    @index.toggle_open()
  render: =>
    @el_template 'entries/entry'
    @color_ms()
    @color_marker()
    @backtrace()
    @lines()
  backtrace:->
    backtrace = @model.get 'backtrace'
    if backtrace
      el = $(@el).find '.backtrace_lines'
      @collect 'backtrace_lines', el: el
      @collection.reset backtrace.lines
  lines:->
    lines = @model.get 'lines'
    if lines
      el = $(@el).find '.lines'
      @collect 'lines', el: el
      @collection.reset lines
  color_marker:->
    backtrace = @model.get 'backtrace'
    c =  if backtrace then 'error'
    else                   'good'
    e = $(@el).find '.marker'
    e.addClass c
  color_ms:->
    ms = @model.get 'duration'
    ms = parseInt ms
    c  = if ms < 500  then 'fast'
    else if ms < 1500 then 'normal'
    else                   'slow'
    e = $(@el).find '.ms'
    e.addClass c
