class App.Views.Shared.FilterController extends Backbone.View
  className: 'filter_controller'
  events:
    'click input:first': 'filter'
  initialize:->
    @render()
  render:->
    @el_template 'shared/filter_controller'
    @collect 'filter_actions',
      el      : @$ '.filter_actions'
      template: 'shared/filter_actions'
    filters = @model.get 'filters'
    @collection.reset filters
  filter:(e)->
    e          = $(e.currentTarget)
    controller = @model.get 'controller'
    checked    = e.is(':checked')
    trigger    = if checked then 'ignore' else 'notice'
    $(@el).find('input').attr 'checked', checked
    App.enteries.filter
      controller : controller
      trigger    : trigger
