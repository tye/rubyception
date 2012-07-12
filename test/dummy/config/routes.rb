Rails.application.routes.draw do

  mount Rubyception::Engine => "/rubyception"
  root to: 'tasks#index'
end
