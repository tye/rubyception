class App.Views.BacktraceLines.Index extends Backbone.View
  initialize: ->
    @bind_render()
  render: =>
    @collection.collect 'tbody'
