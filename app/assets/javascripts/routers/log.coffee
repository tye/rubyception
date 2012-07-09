class App.Routers.Log extends Backbone.Router
  routes:
    '': 'default'
  initialize:->
    socket           = new WebSocket 'ws://localhost:3030/'
    socket.onopen    = @onopen
    socket.onerror   = @onerror
    socket.onclose   = @onclose
    socket.onmessage = @onmessage
    @collection       = new App.Collections.Entries()
    @collection.model = App.Models.Entry
  onopen:        => console.log 'Socket onopen'
  onerror:       => console.log 'Socket onerror'
  onclose:  (msg)=> console.log 'Socket onclose'
  onmessage:(msg)=>
    data = JSON.parse msg.data
    console.log data
    if data.finished
      model = _.last @collection.models
      model.save data
    else
      @collection.add data
  default: ->
    @index()
  toggle_side: =>
    $('.wrapper').toggleClass 'filter'
  hotkeys: ->
    m = Mousetrap
    m.bind '\\ n'       , @toggle_side
    m.bind ['j','down'] , @collection.selection_down
    m.bind ['k','up']   , @collection.selection_up
    m.bind String(i)    , _.bind @store_number_hotkey, @, String(i) for i in [0..9]
    m.bind 'o'          , @collection.open_selected
    m.bind 'shift+g'    , _.bind @go_to_entry_or, @, 'bottom'
    m.bind 'g g'        , _.bind @go_to_entry_or, @, 'top'
  store_number_hotkey: (i) =>
    @number_hotkey ||= ''
    @number_hotkey  += i
  go_to_entry_or: (location) =>
    if @number_hotkey && @number_hotkey != ''
      go_to = @number_hotkey - 1
      if @collection.models[go_to]
        @collection.select_model go_to
    else if @collection.models.length > 0
      if location == 'top'
        @collection.select_model 0
      else if location == 'bottom'
        @collection.select_model @collection.models.length - 1
    @number_hotkey = ''
  index: ->
    @hotkeys()
    @partial '.content', 'logs/show',
      collection: @collection
    entry_1 =
      id         : 1
      controller : 'projects'
      action     : 'index'
      path       : '/all_projects'
      method     : 'get'
      format     : 'html'
      duration   : '255'
      start_time : '2012-05-05 15:13:12'
      lines      : [{name:1},{name:2}]
    entry_2 =
      id         : 2
      controller : 'tasks'
      action     : 'show'
      path       : '/tasks/164/show'
      method     : 'get'
      format     : 'json'
      duration   : '1023'
      start_time : '2012-05-05 15:13:12'
      lines      : [{name:1},{name:2}]
    @collection.reset [entry_1,entry_2]
