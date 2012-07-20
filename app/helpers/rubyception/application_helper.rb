module Rubyception
  module ApplicationHelper
    def display_rails_backtrace_lines_link
      link_to 'T', '#',
          class: 'show_rails',
        onclick: 'return false'
    end
  end
end
