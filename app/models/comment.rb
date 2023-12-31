class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :user, presence: true
  validates :body, presence: true, length: { maximum: 1000 }
end
