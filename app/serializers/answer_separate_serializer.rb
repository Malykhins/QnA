class AnswerSeparateSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :created_at, :updated_at, :user_id
  has_many :links
  has_many :comments
  has_many :files

  def files
    object.files.map do |file|
      {
        filename: file.filename,
        path: rails_blob_path(file, only_path: true)
      }
    end
  end
end
