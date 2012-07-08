class App.Collections.Entries extends Backbone.Collection
  model: App.Models.Entry
  url:-> ''

  initialize: ->
    @selected_index = -1
    if @models.length > 0
      @select_model @selected_index
  open_selection: (n) =>
    @selected_model.trigger 'open' if @selected_model
  select_model: (n) =>
    @selected_model.trigger 'unselect' if @selected_model
    @selected_model = @models[n]
    @selected_index = n
    @selected_model.trigger 'select'
  selection_down: =>
    @selected_index++
    if @selected_index > @models.length - 1
      @selected_index = 0
    @select_model @selected_index
  selection_up: =>
    if @selected_index <= 0
      @selected_index = @models.length - 1
    else
      @selected_index--
    @select_model @selected_index
