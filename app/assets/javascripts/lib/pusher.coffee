window.Backpusher = (channel, collection, options) ->
  return new Backpusher(channel, collection, options) unless this instanceof Backpusher

  if channel.pusher.connection
    action = channel.pusher.connection
    ev     = 'connected'
  else
    action = channel.pusher
    ev     = 'pusher:connection_established'

  action.bind ev, -> Backbone.pusher_socket_id = action.socket_id

  @options    = options or {}
  @channel    = channel
  @collection = collection
  @events     = if @options.events then @options.events else Backpusher.defaultEvents

  @_bindEvents()
  @initialize channel, collection, options

_.extend Backpusher::, Backbone.Events,
  initialize: ->
  _bindEvents: ->
    return unless @events
    for event of @events
      @channel.bind event, _.bind(@events[event], this)
  _add: (model) ->
    Collection = @collection
    model      = new Collection.model model
    Collection.add model
    @trigger 'remote_create', model
    model

Backpusher.defaultEvents =
  created: (pushed_model) ->
    @_add pushed_model
  updated: (pushed_model) ->
    model = @collection.get pushed_model
    if model
      model = model.set pushed_model
      @trigger 'remote_update', model
      model
    else
      @_add pushed_model

  destroyed: (pushed_model) ->
    model = @collection.get pushed_model
    if model
      @collection.remove model
      @trigger 'remote_destroy', model
      model

sync = Backbone.sync
Backbone.sync = (method,model,options)->
  headers         = options.headers
  push_header     = { 'X-Pusher-Socket-ID': Backbone.pusher_socket_id }
  options.headers = _.extend push_header, headers
  sync method, model, options

