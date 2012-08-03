Rails.application.routes.draw do

  mount Rubyception::Engine => "/rubyception"
  root to: 'tasks#index', all_done: true, project_name: 'Zeus', tasks_count: 235
end
