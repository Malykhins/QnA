# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    member do
      post :vote_up, :vote_down
      delete :unvote
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable, shallow: true do
      patch 'set_best', on: :member
    end
  end

  resources :links, only: [:destroy]
  resources :rewards, only: [:index]

  mount ActionCable.server => '/cable'
end
