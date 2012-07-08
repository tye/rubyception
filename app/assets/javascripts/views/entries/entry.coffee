class App.Views.Entries.Entry extends Backbone.View
  className: 'entry'
  events:
    'click': 'toggle'
  initialize: ->
    @model.bind 'change', @render
    @model.bind 'unselect', @unselect
    @model.bind 'select', @select
    @model.bind 'open', @toggle
    @render()
  select: =>
    $(@el).addClass 'selected'
  unselect: =>
    $(@el).removeClass 'selected'
  render: =>
    attrs = @model.attrs()
    @el_template 'entries/entry', attrs
    @color_ms()
    @color_marker()
    @backtrace()
  backtrace:->
    backtrace = @model.get 'backtrace'
    if backtrace
      console.log 'backtRACEEE!'
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
  toggle:->
    $(@el).toggleClass 'open'

    #lines_data = @model.get 'lines'
    #@collect 'lines'
    #@collection.reset lines_data
