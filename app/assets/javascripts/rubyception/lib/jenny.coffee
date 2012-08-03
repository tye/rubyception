$.ajaxSetup
  beforeSend:(xhr)->
    xhr.setRequestHeader 'Accept', 'application/json'
  cache: false

ViewHelpers=
  el_template:(path)->
    attrs = {}
    attrs = @model.attrs() if @model
    html  = @template path, attrs
    $(@el).html html
  fire:(event)->
    $(@el).trigger event
  bind_render:->
    _.bindAll        @      , 'render'
    @collection.bind 'add'  , @add
    @collection.bind 'reset', @render
  validate:->
    Backbone.Validation.bind @,
      invalid: (view, attr, error, selector)->
        l = $("label[for=document_#{attr}]").html()
        $('.errors').addClass 'on'
        $('.errors').append "<tr class='error'><td class='name'>#{l}</td><td>#{error}</td></tr>"

ModelHelpers=
  get:(attr)->
    old_attr    = @attributes[attr]
    is_function = typeof @[attr] is 'function'
    return @[attr](old_attr) if is_function
    old_attr
  attrs:->
    attrs       = {}
    self        = @
    attrs       = @toJSON()
    attrs['id'] = @id if @id
    _.each attrs, (value,attr)=>
      attrs[attr] = @get attr
    attrs
CollectionHelpers =
  # @collection.collect
  # ---------------
  #
  # This method is best used with the BackboneHelpers.collect
  # In your view that has a collection you can call collect on
  # the collection and it will render the the individual models
  # if you used BackboneHelpers.collect to render the current
  # view all you have to do now is:
  #
  #    (assuming @collect 'projects' was called)
  #    @collection.collect
  #
  #  This would render the template 'projects/index' and attach
  #  it the '.projects'
  #
  #  if you don't want to render a template because it already exists
  #  you can just set has_template_index to false
  collect:->
    e         = $ @context.el
    find      = arguments[0]
    has_find  = find isnt undefined && find isnt null
    options   = arguments[1]
    options ||= {}

    ti   = options.template_index
    delete options.template_index
    template_index = ti
    template_index = "#{@name}/index" if ti is undefined

    hti  = options.has_template_index
    delete options.has_template_index
    if hti != false
      html = @context.template template_index, options.args || {}
      e.html html 

    t    = options.template
    delete options.template
    template = "#{@name}/#{@name.singularize()}"
    template = t if t isnt undefined
    selector = e
    selector = e.find(find) if has_find
    primer   =  options.primer || template_index
    selector.html ''

    p = options.primer
    delete options.primer
    if @length == 0 && p
      html = @context.template "#{primer}_primer", {}
      e.html html
    else
      for model in @context.collection.models
        options['model'] = model
        e = @context.partial null, template, options
        selector.append e.el
BackboneHelpers =
  redirect_on_browse:->
    if @browsing()
      return window.location.pathname = '/signup'
    else
      false
  browsing:->
    $('body').hasClass('logged_out')
  hash:(i=null)->
    e = window.location.hash.replace /#/, ''
    e = e.replace /\?.+$/, ''
    e = e.split '/'
    if i then e[i] else e
  template: (path,data)->
    template = null
    eval "template = Template.#{path.replace(/\//g,'.')}"
    throw "template is undefined: Template.#{path.replace(/\//g,'.')}" if template is undefined
    Milk.render template, data

  # collect
  # ---------------
  # This method makes it easy to quickly render a collection.
  # all you need to do is pass in the name of the collection you
  # want to be rendered eg.
  #
  #    collect 'projects'
  #
  # If your dealing with an association:
  #
  #   collect 'projects/tasks', id: 5
  #
  # It will create a collection in this case App.Collections.Projects
  # with the model being App.Models.Project and an url with '/projects'.
  # The collection will be assigned to the @collection instance variable
  # so you can reference it in your view. It will not invoke fetch().
  #
  # It will also called @partial '.projects', 'projects/index' and
  # attach the collection and whatever options you pass to to the
  # collect method.
  #
  # If you want to override the el of the partial you just need to specify
  # the el the option. eg.
  #
  #    @collect 'users', el: '.people'
  #
  # If you want to override the partial path thats being used in the partial you just
  # need to specify the template option (probably should not be called template since
  # that might confuse people with the actual template being render) eg.
  #
  #    #collect 'users', template: 'awesome_people/index'
  #
  # If you want to override the model being use you need to pass just the
  # model name to the model option eg.
  #
  #    @collect 'groups', model: 'community'
  #
  collect:->
    name      = arguments[0]
    options   = arguments[1]
    options ||= {}

    url   = options.url if options.url

    url ||= if name.match(/\//)
      e        = name.split '/'
      context  = e[0]
      name     = e[1]
      reg      = new RegExp "#{context}\\/(\\d+)"
      id       = options.id
      "/api/#{context}/#{id}/#{name}"
    else
      "/api/#{name}"
    klass      = name.camelize()
    has_model  = options['model'] isnt undefined
    model_name = if has_model
      model_name = options['model']
      delete options['model']
      model_name.camelize()
    else if @model_name
      model_name = @model_name
      model_name.camelize()
    else
      klass.singularize()
    @collection = if @options.collection isnt undefined
      collection = options['collection']
      delete options['collection']
      collection
    else
      new App.Collections[klass]
    result_model = @result_model || "#{model_name}Result"
    if App.Models[result_model]
      @collection.results_model = new App.Models[result_model]()
      @collection.results_model.collection = @collection
    @collection.url   = url
    @collection.model = App.Models[model_name]
    @collection.name  = name
    options                 ||= {}
    options.collection        = @collection

    selector = ".#{name}"
    if options['el'] isnt undefined
      selector = options['el']
      delete options['el']

    template = "#{name}/index"
    if options['template'] isnt undefined
      template = options['template']
      delete options['template']
    e = @partial selector, template, options
    @collection.context = e
    @collection
  partial:->
    el      = arguments[0]
    name    = arguments[1]
    options = arguments[2]
    scope = 'App'
    if name.match /admin/
      scope = 'Admin'
      name = name.replace /admin\//, ''
    e              = name.split '/'
    options      ||= {}
    options['el']  = el if el != null
    p = (item.camelize() for item in e)
    eval "var p = new #{scope}.Views.#{p.join('.')}(options)"
    instance_var = e.join('_')
    @[instance_var] = p
  post:(url,success,data)->
    token = $("meta[name='csrf-token']").attr('content')
    data['authenticity_token'] = token
    $.ajax
      type     : 'post'
      url      : url,
      data     : data
      dataType : 'json'
      context  : this
      success  : success
  get:(url,success,data)->
    $.ajax
      url      : url,
      data     : data
      dataType : 'json'
      context  : this
      success  : success
  resize:->
    App.Helpers.Base.resize_panels()
_.extend Backbone.Router.prototype    , BackboneHelpers
_.extend Backbone.View.prototype      , BackboneHelpers
_.extend Backbone.View.prototype      , ViewHelpers
_.extend Backbone.Model.prototype     , ModelHelpers
_.extend Backbone.Collection.prototype, CollectionHelpers



cx_backbone_common =
  sync: (method, model, options) ->
    # Changed attributes will be available here if model.saveChanges was called instead of model.save
    if method == 'update' && model.changedAttributes()
      options.data = JSON.stringify(model.changedAttributes())
      options.contentType = 'application/json';
    Backbone.sync.call(this, method, model, options)

cx_backbone_model =
  # Calling this method instead of set will force sync to only send changed attributes
  # Changed event will not be triggered until after the model is synced
  saveChanges: (attrs) ->
    @save(attrs, {wait: true})

_.extend(Backbone.Model.prototype, cx_backbone_common, cx_backbone_model)
_.extend(Backbone.Collection.prototype, cx_backbone_common)
