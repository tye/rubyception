class App.Views.Shared.Filters extends Backbone.View
  initialize:->
    App.filters = {}
    @render()
  render:->
    $(@el).empty()
    _.each App.filters, (v,k)=>
      v = _.map v, (action)=> 
        {controller: k, action: v}
      attrs = 
        controller : k
        filters    : v
      model = new Backbone.Model attrs
      e = @partial null, 'shared/filter_controller', model: model
      $(@el).append e.el
