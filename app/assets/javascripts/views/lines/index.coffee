class App.Views.Lines.Index extends Backbone.View
  initialize: ->
    @bind_render()
  render: =>
    @collection.collect()
