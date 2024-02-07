# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  concern :votable do
    member do
      post :vote_up, :vote_down
      delete :unvote
    end
  end

  concern :commentable do
    post :create_comment, on: :member
  end

  resources :questions, concerns:  %i[votable commentable] do
    resources :answers, concerns:  %i[votable commentable], shallow: true do
      patch 'set_best', on: :member
    end
  end

  resources :links, only: [:destroy]
  resources :rewards, only: [:index]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: [:index] do
        resources :answers, shallow: true
      end
    end
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
