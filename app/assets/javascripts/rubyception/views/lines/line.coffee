class App.Views.Lines.Line extends Backbone.View
  tagName: 'tr'
  className: 'line'
  initialize: ->
    @render()
  render: ->
    kind = @model.get 'kind'
    hook = @model.get 'hook'
    @el_template "lines/#{kind}/#{hook}"
    $(@el).addClass "#{kind} #{hook}"
