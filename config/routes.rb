Rails.application.routes.draw do
  resources :borrower, only: [:create, :show] do
    resources :debt, only: [:create, :show, :index]
  end
end
