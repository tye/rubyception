class App.Views.Entries.Entry extends Backbone.View
  className: 'entry'
  events:
    'click': 'select_and_toggle'
  initialize: ->
    @model.bind 'notice', @notice
    @model.bind 'ignore', @ignore
    @render()
  select_and_toggle: (event) =>
    target = $ event.target
    # Return unless we clicked directory on .details, or .heading, or a child of .heading
    return unless target.hasClass('details') or target.closest('.heading').length > 0 or target.hasClass('entry')
    unless $(@el).hasClass 'selected'
      @index.entry $ @el
    @index.toggle_open()
  render: =>
    @add_to_filters()
    @el_template 'entries/entry'
    @color_ms()
    @color_marker()
    @backtrace()
    @lines()
  backtrace:->
    backtrace = @model.get 'backtrace'
    if backtrace
      el = $(@el).find '.backtrace_lines'
      @collect 'backtrace_lines',
        el: el
        name: backtrace.name
        message: backtrace.message
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
  ignore:=> $(@el).addClass 'ignore'
  notice:=> $(@el).removeClass 'ignore'
  add_to_filters:->
    controller = @model.get 'controller'
    action     = @model.get 'action'
    App.filters[controller] = [] if App.filters[controller] is undefined
    App.filters[controller].push action
    App.filters[controller] = _.uniq App.filters[controller]
    App.column.render()
