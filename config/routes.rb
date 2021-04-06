Rails.application.routes.draw do
  resources :borrower, only: [:create, :show] do
    resources :debt, only: [:create, :show, :index] do
      put :autofill
      get :payoff_amount
    end
  end
end
