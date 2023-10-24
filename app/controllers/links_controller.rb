class LinksController < ApplicationController
  def destroy
    @link = Link.find(params[:id])
    object = @link.linkable

    return unless current_user.author_of?(object)
    @link.destroy

    if @link.destroyed?
      flash.now[:notice] = 'Link successfully deleted!'
    else
      flash.now[:error] = 'Error deleting the link!'
    end

    if object.is_a?(Question)
      redirect_to question_path(object)
    elsif object.is_a?(Answer)
      redirect_to question_path(object.question)
    end
  end
end
