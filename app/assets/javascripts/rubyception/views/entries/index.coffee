class App.Views.Entries.Index extends Backbone.View
  initialize: ->
    @bind_render()
  render:=>
    @collection.collect()
  add:(model)=>
    e = @partial null, 'entries/entry',
        model: model
    $(@el).append e.el
