class Rubyception::TemplatesController < ApplicationController
  layout false

  helper :all

  def index
    @templates = {}
    respond_to do |f|
      f.js
    end
  end
end
