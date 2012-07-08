class App.Views.Lines.Line extends Backbone.View
  className: 'line'
  initialize: ->
    @render()
  render: ->
    attrs = @model.attrs()
    @el_template 'lines/line', attrs
