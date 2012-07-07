class App.Views.Logs.Show extends Backbone.View
  events: {}
  initialize: ->
    @render()
  render: ->
    @collect 'entries'
    @collection.reset [{id:1},{id:2}]
