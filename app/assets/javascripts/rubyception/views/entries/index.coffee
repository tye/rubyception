class App.Views.Entries.Index extends Backbone.View
  initialize: ->
    @bind_render()
    $(window).unbind 'blur'
    $(window).bind 'blur', @add_marker
    @$el = $(@el)
  add_marker: =>
    first_child = @$el.children().first()
    if first_child.length > 0 and not first_child.hasClass 'position_marker'
      @$el.prepend '<div class="position_marker"></div>'
  render:=>
    @collection.collect()
  add:(model)=>
    e            = @partial null, 'entries/entry',
                     model: model,
    e.index      = @
    e.entries = @collection
    $(@el).prepend e.el
  number_hotkey: (i) =>
    @stored_number ||= ''
    @stored_number  += i
  goto_number: (location) =>
    n = 0
    if @stored_number == ''
      n = NaN
    else
      n = Number(@stored_number)
      @stored_number = ''

    if isNaN n || !n
      n = 1

    n--  # array of items is 0 indexed

    entries = @$el.find '.entry'
    if entries.get(n)
      @entry $ entries.get(n)
    else
      if location == 'top'
        @entry entries.first()
      else if location == 'bottom'
        @entry entries.last()
    @toggle_open()
  toggle_open: =>
    if selected = @current()
      selected.toggleClass 'open'
      window.scrollTo 0, selected.offset().top
  current: =>
    selected = @$el.find '.selected'
    if selected.length == 0
      false
    else
      selected
  deselect: =>
    if selected = @current()
      selected.removeClass('selected').
        removeClass('open')
  down:(event)=>
    if selected = @current()
      next_e = selected.nextAll '.entry'
      if next_e.length == 0
        next_e = @$el.find('.entry').first()
    else
      next_e = @$el.find('.entry').first()
    @entry next_e.first()
    event.preventDefault()
  up: (event) =>
    if selected = @current()
      next_e = selected.prevAll '.entry'
      if next_e.length == 0
        next_e = @$el.find('.entry').last()
     else
       next_e = @$el.find('.entry').last()
    @entry next_e.first(), -500
    event.preventDefault()
  entry: (e,scroll_offset=-100) =>
    @deselect()
    window.scrollTo 0, e.offset().top + scroll_offset
    e.addClass 'selected'
