# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root to: 'questions#index'

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

  mount ActionCable.server => '/cable'
end
