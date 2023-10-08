class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  def mark_as_best(checkbox_param)
    transaction do
      self.class.where(question_id: self.question_id).update_all(best: false)
      update(best: checkbox_param)
    end
  end
end
