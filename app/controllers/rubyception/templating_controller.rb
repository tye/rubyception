class Rubyception::TemplatingController < AbstractController::Base
  include AbstractController::Logger
  include AbstractController::Rendering
  include AbstractController::Layouts
  include AbstractController::Helpers
  include AbstractController::Translation
  include AbstractController::AssetPaths
  include Rails.application.routes.url_helpers

  self.view_paths = 'app/views'
  self.assets_dir = 'app/public'

  helper ApplicationHelper,
         JennyHelper

  public
    def r partial
      render :partial => partial
    end

end
