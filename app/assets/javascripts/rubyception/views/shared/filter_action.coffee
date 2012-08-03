class App.Views.Shared.FilterAction extends Backbone.View
  className: 'filter_action'
  events:
    'click input': 'filter'
  initialize:->
    @render()
  render:->
    @el_template 'shared/filter_action'
  filter:(e)->
    parent   = $(e.currentTarget).parent().parent().parent()
    checked  = parent.find('input:first').is(':checked')
    if checked is false
      controller = @model.get 'controller'
      action     = @model.get 'action'
      checked    = $(e.currentTarget).is(':checked')
      trigger    = if checked then 'ignore' else 'notice'
      App.enteries.filter
        controller : controller
        aciton     : action
        trigger    : trigger
