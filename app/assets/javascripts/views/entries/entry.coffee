class App.Views.Entries.Entry extends Backbone.View
  className: 'entry'
  initialize: ->
    @render()
  render: ->
    console.log 'RENDER ENTRIES ENTRY'
    attrs = @model.attrs()
    @el_template 'entries/entry', attrs
