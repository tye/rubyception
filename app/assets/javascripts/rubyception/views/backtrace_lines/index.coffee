class App.Views.BacktraceLines.Index extends Backbone.View
  events:
    'click a.show_rails': 'show_rails_lines'
  initialize: ->
    @bind_render()
  render: =>
    @collection.collect 'tbody'
  show_rails_lines: (event) =>
    $(@el).toggleClass 'display_rails'
    event.stopPropagation()
