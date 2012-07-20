class App.Views.Entries.Index extends Backbone.View
  initialize: ->
    @bind_render()
    $(window).unbind 'blur'
    $(window).bind 'blur', @add_marker
    @$el = $(@el)
  add_marker: =>
    first_child = @$el.children().first()
    if first_child.length > 0 and not first_child.hasClass 'position_marker'
      @$el.prepend '<div class="position_marker"></div>'
  render:=>
    @collection.collect()
  add:(model)=>
    e            = @partial null, 'entries/entry',
                     model: model,
    e.index      = @
    e.entries = @collection
    $(@el).prepend e.el
