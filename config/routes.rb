Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :task do
    collection do
      get 'by_status', to: 'task#tasks_by_status'
    end
  end
end
