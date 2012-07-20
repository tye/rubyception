class App.Views.BacktraceLines.BacktraceLine extends Backbone.View
  tagName  : 'tr'
  className: 'backtrace_line'
  initialize:->
    @render()
  render:->
    @el_template 'backtrace_lines/backtrace_line'
    $(@el).addClass 'rails' if @model.get('rails')
