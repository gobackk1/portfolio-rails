class TeachingMaterialsController < ApplicationController
  before_action :current_user

  def index
    materials = TeachingMaterial.where(user_id: params[:user_id])
    render json: materials
  end

  def create
    material = TeachingMaterial.new(material_params)
    material.user_id = @current_user.id

    if material.save
      if params[:image_select]
        path = "/images/user_images/#{@current_user.id}"
        material.update_attribute(:image_url, "#{path}/#{material.id}/#{Time.now.to_i}.jpg")
        Dir.mkdir("public/api/#{path}/#{material.id}")
        File.binwrite("public/api/#{material.image_url}", Base64.decode64(params[:image_select]))
      end
      render json: material
    else
      render json: {messages: material.errors.full_message}
    end
  end

  def destroy
    material = TeachingMaterial.find(params[:id])

    if material.user_id == @current_user.id
      if material.destroy
        render json: params[:id]
      end
    else
      render json: {messages: ['別のユーザーの教材を削除しようとしました。']}
    end
  end

  private
    def material_params
      params.permit(:title)
    end
end
