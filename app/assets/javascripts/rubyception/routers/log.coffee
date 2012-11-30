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
    App.enteries      = @collection
    @collection.model = App.Models.Entry
    @default()
  onmessage:(msg)=>
    data = JSON.parse msg.data
    if data.finished
      @finished = data
      #model = _.last @collection.models
      #model.set data
    else
      @started = data

    if @started && @finished
      data = @finished
      delete data.id
      @started  = false
      @finished = false
      @collection.add data
  default: ->
    @index()
  toggle_params: =>
    expanded_entry = $('.entry.selected.open')
    if expanded_entry.length > 0
      expanded_entry.find('.params').toggleClass 'nested'
  toggle_side: =>
    $('.wrapper').toggleClass 'filter'
  hotkeys: =>
    m = Mousetrap
    m.bind '\\ n'       , @toggle_side
    m.bind ['j','down'] , @log.entries_index.down
    m.bind ['k','up']   , @log.entries_index.up
    m.bind String(i)    , _.bind @log.entries_index.number_hotkey, @, String(i) for i in [0..9]
    m.bind 'shift+g'    , _.bind @log.entries_index.goto_number, @, 'bottom'
    m.bind 'g g'        , _.bind @log.entries_index.goto_number, @, 'top'
    m.bind 'p'          , @toggle_params
    m.bind ['o','enter'], @log.entries_index.toggle_open
  index: =>
    App.column = @partial '.column', 'shared/filters'
    @log = @partial '.content', 'logs/show',
      collection: @collection
    @hotkeys()
