#= require jquery
#= require jquery_ujs
#= require lib/underscore-min
#= require lib/backbone
#= require lib/pusher
#= require lib/milk
#= require lib/inflections
#= require lib/jenny
#= require init
#= require_tree ./routers
#= require_tree ./views
#= require_tree ./collections
#= require_tree ./models
$ ->
  new App.Routers.Log()
  Backbone.history.start
    pushState: true
