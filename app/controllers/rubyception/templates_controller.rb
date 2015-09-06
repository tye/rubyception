module Rubyception
  class TemplatesController < AbstractController::Base
    include AbstractController::Rendering
    if defined?(AbstractController::Layouts)
      include AbstractController::Layouts
    else
      include ActionView::Layouts
    end
    include ActionController::Helpers

    self.view_paths = Rubyception::Engine.root.join('app','templates')
    #self.helpers_path = Rubyception::Engine.root.join('app','helpers')

    def self.render_templates
      controller = TemplatesController.new
      result = {}
      files = []
      view_paths.each do |path|
        files += Dir[Pathname.new(path.to_path).join('**','*')]
      end
      files.reject!{|f| File.basename(f)[0] == '_'}
      files.each do |file|
        if m = file.match(/.*?\/app\/templates\/(.*?)\./)
          template_name = m[1]
          result[template_name] = controller.render(template: template_name)
        end
      end
      result
    end
  end
end

