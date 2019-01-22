class UploadController < ApplicationController

  def image
    uploader = ImageUploader.new
    uploader.store!(params[:image])
    flash[:notice] = "Файл загружен"

    render :json => {
        :link => uploader.url,
        :thumb => uploader.thumb.url
    }
  end

  def file

  end

end