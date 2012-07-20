module Rubyception
  module ApplicationHelper
    def display_rails_backtrace_lines_link
      link_to 'Show Rails', '#',
          class: 'show_rails',
        onclick: 'return false'
    end
  end
end
