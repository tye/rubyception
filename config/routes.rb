Rubyception::Engine.routes.draw do
  get '/templates' => 'templates#index'
  root to: 'application#index'
end
