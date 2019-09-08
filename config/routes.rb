Rails.application.routes.draw do

	root 'sessions#new'

  resources :users, only: [:new, :create, :destroy]
  resources :sessions, only: [:new, :create, :destroy]
  resources :passwords, only: [:new, :forgot, :reset]

  get 'signup', to: 'users#new'
	get 'profile', to: 'users#edit'
	put 'update_profile', to: 'users#update'
	put 'update_password', to: 'users#update_password'
  get 'login', to: 'sessions#new'
	post 'login_attempt', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
  get 'forgot_password', to: 'passwords#forgot'
	get 'confirm_token', to: 'passwords#confirm_token'
	post 'create_token', to: 'passwords#create_token'
	get 'reset_password', to: 'passwords#reset'
end