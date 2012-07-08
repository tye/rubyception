class App.Views.Logs.Show extends Backbone.View
  events: {}
  initialize: ->
    @render()
  render: ->
    @collect 'entries',
      el        : '.content'
      collection: @collection
