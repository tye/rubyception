class App.Views.Entries.Index extends Backbone.View
  initialize: ->
    @bind_render()
  render:=>
    @collection.collect()
  add:(model)=>
    e = @partial null, 'entries/entry',
        collection: @collection,
        model: model,
        index: @
    $(@el).append e.el
