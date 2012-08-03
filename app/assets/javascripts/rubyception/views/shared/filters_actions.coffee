class App.Views.Shared.FilterActions extends Backbone.View
  initialize:->
    @bind_render()
  render:->
    @collection.collect null,
       template           : 'shared/filter_action'
       has_template_index : false
