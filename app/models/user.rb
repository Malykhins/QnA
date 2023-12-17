# frozen_string_literal: true
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github google_oauth2 ]


  has_many :questions
  has_many :answers
  has_many :rewards, dependent: :destroy
  has_many :votes
  has_many :authorizations, dependent: :destroy

  def author_of?(item)
    id == item.user_id
  end

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end
end
