Rubyception::Engine.routes.draw do
  get '/logs' => 'logs#index'
  root to: 'application#index'
end
