class App.Views.Entries.Index extends Backbone.View
  initialize: ->
    @bind_render()
  render: ->
    console.log 'RENDER ENTIRS INDEx'
    @collection.collect()
