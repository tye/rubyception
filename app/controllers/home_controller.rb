class HomeController < ApplicationController
  def index
  end

  def error
    raise 'OMFG'
  end
end
