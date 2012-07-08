Rubyception::Application.routes.draw do
  root to: 'home#index'
  get '/error' => 'home#error'
end
