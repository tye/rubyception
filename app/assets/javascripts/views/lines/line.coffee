class App.Views.Lines.Line extends Backbone.View
  className: 'line'
  initialize: ->
    @render()
  render: ->
    @el_template 'lines/line'
