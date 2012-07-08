class App.Views.Lines.Index extends Backbone.View
  initialize: ->
    #@render()
  render: ->
    @collection.collect()
