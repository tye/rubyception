class App.Collections.Entries extends Backbone.Collection
  model: App.Models.Entry
  url:-> ''
  filter:(args)->
    _.each @models, (model)=>
      controller       = model.get 'controller'
      action           = model.get 'action'
      check_action     = args.controller isnt undefined and args.action isnt undefined
      check_controller = args.controller isnt undefined 

      trigger = if check_action
        controller is args.controller && action is args.action
      else if check_controller
        controller is args.controller
      else
        false

      if trigger && args.trigger is 'ignore'
        model.trigger 'ignore' 
      else if trigger && args.trigger is 'notice'
        model.trigger 'notice'
