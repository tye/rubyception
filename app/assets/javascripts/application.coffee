#= require jquery
#= require jquery_ujs
#= require lib/underscore-min
#= require lib/backbone
#= require lib/pusher
#= require lib/milk
#= require lib/inflections
#= require lib/jenny
#= require template
#= require init
#= require_tree ./routers
#= require_tree ./views
#= require_tree ./collections
#= require_tree ./models
$ ->
  new App.Routers.Log()
  Backbone.history.start
    pushState: true

  window.start_server = ->
    top.socket = new WebSocket 'ws://localhost:3030/'
    socket.onopen = ->
      console.log 'Socket opened'
    socket.onmessage = (msg) ->
      console.log 'Message received:'
      console.log msg
      json = JSON.parse msg.data
      e    = $('.container')
      if json.type is 'entry'
        e.append json.html + '\n'
      else 
        is_backtace = json.type is 'backtrace'
        e           = e.find('.entry:last-child')
        e.append json.html if is_backtrace

    socket.onerror = ->
      console.log "On Error"

    socket.onclose = (msg) ->
      console.log 'Socket closed'
    window.send_data = (msg) ->
      console.log 'Message sent:'
      console.log msg
      socket.send msg
  start_server()

