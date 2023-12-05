module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: %i[create_comment]
    after_action :public_comment, only: %i[create_comment]
  end

  def create_comment
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))

    if @comment.persisted?
      flash.now[:notice] = 'Comment successfully created!'
    else
      flash.now[:alert] = 'Error creating a comment!'
    end

    render 'comments/creation_messages'
  end

private

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def public_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast('comments_channel',
                                 comment_body: @comment.body,
                                 comment_author_id: current_user.id,
                                 commentable_id: @commentable.id,
                                 klass_name: @commentable.class.name.downcase)
  end
end
