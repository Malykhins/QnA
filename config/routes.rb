# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    resources :answers, shallow: true do
      patch 'set_best', on: :member
    end
  end

  resources :links, only: [:destroy]
end
