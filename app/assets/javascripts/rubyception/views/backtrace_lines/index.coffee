class App.Views.BacktraceLines.Index extends Backbone.View
  events:
    'click a.show_rails': 'show_rails_lines'
  initialize: ->
    @message = @options.message
    @name = @options.name
    @bind_render()
  render: =>
    @collection.collect 'tbody',
      args:
        name: @name
        message: @message
  show_rails_lines: (event) =>
    $(@el).toggleClass 'display_rails'
    event.stopPropagation()
