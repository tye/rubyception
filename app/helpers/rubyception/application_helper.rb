module Rubyception
  module ApplicationHelper
    def display_rails_backtrace_lines_link
      link_to 'T', '#',
          class: 'show_rails',
        onclick: 'return false'
    end
    def parse_tree tree, parents=[], result={}
      if tree.is_a?(String)
          item = result
          parents.each do |parent|
            item[parent] ||= {}
            item = item[parent]
          end
          item[tree] = render(partial: "rubyception/#{parents.join('/')}/#{tree}")
      elsif tree.is_a?(Hash)
        tree.each do |key, val|
          parse_tree val, parents + [key], result
        end
      elsif tree.is_a?(Array)
        tree.each do |val|
          parse_tree val, parents, result
        end
      end
      result
    end
  end
end
