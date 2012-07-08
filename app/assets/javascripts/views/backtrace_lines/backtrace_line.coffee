class App.Views.BacktraceLines.BacktraceLine extends Backbone.View
  className: 'backtrace_line'
  initialize:->
    @render()
  render:->
    @el_template 'backtrace_lines/backtrace_line'
