class App.Views.BacktraceLines.Index extends Backbone.View
  initialize: ->
    @bind_render()
  render: =>
    console.log @collection
    @collection.collect 'tbody'

