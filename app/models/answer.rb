class Answer < ApplicationRecord
  include Votable

  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  has_many_attached :files

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc, updated_at: :desc) }

  def mark_as_best(checkbox_param)
    transaction do
      question.answers.update_all(best: false)
      update!(best: checkbox_param)

      question.reward&.update!(user: user) if checkbox_param
    end
  end
end
