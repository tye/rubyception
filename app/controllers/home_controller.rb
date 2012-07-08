class HomeController < ApplicationController
  def index
  end

  def view
    render
  end

  def error
    raise 'OMFG'
  end
end
