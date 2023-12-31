class LinksController < ApplicationController
  authorize_resource

  def destroy
    @link = Link.find(params[:id])
    object = @link.linkable

    return head(403) unless can? :destroy, object

    @link.destroy

    if @link.destroyed?
      flash.now[:notice] = 'Link successfully deleted!'
    else
      flash.now[:error] = 'Error deleting the link!'
    end
  end
end
