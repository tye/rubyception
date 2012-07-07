class App.Routers.Log extends Backbone.Router
  routes:
    '': 'default'
  default: ->
    @index()
  index: ->
    @partial '.content', 'logs/show'
