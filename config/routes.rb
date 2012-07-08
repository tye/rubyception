Rubyception::Application.routes.draw do
  root to: 'home#index'
  get '/error' => 'home#error'
  get '/view' => 'home#view'
end
