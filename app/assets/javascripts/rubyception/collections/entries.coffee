class App.Collections.Entries extends Backbone.Collection
  model: App.Models.Entry
  url:-> ''

  initialize: ->
    @selected_index = -1
    if @models.length > 0
      @select_model @selected_index
  close_selected: =>
    @selected_model.trigger 'close' if @selected_model
  open_selected: =>
    @selected_model.trigger 'open' if @selected_model
  select_model: (n) =>
    # This is kind of messy, but we need to know the numeric index of the model we are selecting
    if typeof n == 'object'
      x = 0
      for model in @models
        if model == n
          break
        x++
      n = x
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
