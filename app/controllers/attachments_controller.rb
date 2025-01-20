class AttachmentsController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  def destroy
    file = ActiveStorage::Attachment.find(params[:id])
    logger.debug "Attempting to destroy file: #{file.filename}"
    authorize! :destroy, file
    file.purge
  end
end
