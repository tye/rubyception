console.log "Init angular app"
window.app = angular.module('rubyception', [])

console.log "Adding controller"
controller = ($scope) ->
  $scope.entries = []
  $scope.open = (model) -> model.opened = true

  $scope.classes = (model)->
    open: model.opened

  $scope.line_template = (line)->
    "lines/#{line.kind}/#{line.hook}"

  onopen = ->
    console.log "Opened"
  onmessage = (e)->
    $scope.$apply ->
      $scope.entries.push JSON.parse(e.data)
    console.log "Message", JSON.parse(e.data)
  event_source = new EventSource("/rubyception/logs")
  event_source.onmessage = onmessage
  event_source.onopen = onopen

  event_source.addEventListener 'rubyception', onmessage, false
app.controller 'LogCtrl', ['$scope', controller]

filter = ($templateCache)->
  (line)->
    template_name = "lines/#{line.kind}/#{line.hook}"
    template_name = template_name.replace(/[^a-z0-9\-_\.\/]/gi,'')
    template = $templateCache.get(template_name)
    if template
      template_name
    else
      console.log "Template", template_name, "does not exist"
      'lines/default'
app.filter 'line_template', ['$templateCache', filter]


escape = (value)->
  value.replace('&','&amp;').replace('<','&lt;').replace('>','&gt;')
directive = ($compile) ->
  scope:
    params: "=params"
  link:(scope,element,attrs)->
    frag = $ '<div class="list">'
    x = 0
    if angular.isArray(scope.params)
      element.addClass 'array'
      for v of scope.params
        dd = $ '<div class="value">'
        scope["value_#{x}"] = v
        dd.attr 'params', "value_#{x}"
        x += 1
        frag.append dd
        frag.append $ '<div class="clear">'
      element.append $compile(frag)(scope)
    else if angular.isObject(scope.params)
      element.addClass 'object'
      for own k,v of scope.params
        dt = $ '<div class="key">'
        dt.html escape(k)
        dd = $ '<div class="value">'
        scope["value_#{x}"] = v
        dd.attr 'params', "value_#{x}"
        x += 1
        frag.append dt
        frag.append dd
        frag.append $ '<div class="clear">'
      element.before $compile($ '<a class="toggle" toggle-params>')(scope)
      element.append $compile(frag)(scope)
    else
      element.html escape(scope.params) if typeof scope.params == 'string'
app.directive 'params', ['$compile', directive]

sql_highlight = ->
  link:(scope,element,attrs)->
    unwatch = scope.$watch 'model.opened', (newv,oldv)->
      console.log "opened", newv
      if newv
        elms = element.find('code.lang-sql')
        for e in elms
          hljs.highlightBlock(e)
        unwatch()
app.directive 'highlightingOnOpen', [sql_highlight]

toggle_params = ->
  link:(scope,element,attrs)->
    element.on 'click', ->
      element.next('.value, .base_params').toggleClass 'collapsed'
      element.toggleClass 'collapsed'
app.directive 'toggleParams', [toggle_params]

simple_pluralize = ->
  scope:
    'word': '@word'
    'count': '=count'
  link:(scope,element,attrs)->
    if scope.count == 1
      element.html scope.word
    else
      element.html scope.word + 's'
app.directive 'simplePluralize', [simple_pluralize]
