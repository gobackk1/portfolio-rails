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
        set_image material, params[:image_select]
      end
      render json: material
    else
      render json: {messages: material.errors.full_message}
    end
  end

  def update
    material = TeachingMaterial.find(params[:id])
    material.title = params[:title]

    if material.save
      if params[:image_select]
        FileUtils.rm_rf("public/api/images/user_images/#{material.user_id}/#{material.id}")
        set_image material, params[:image_select]
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

    def set_image(material, image)
      path = "/images/user_images/#{material.user_id}"
      material.update_attribute(:image_url, "#{path}/#{material.id}/#{Time.now.to_i}.jpg")
      Dir.mkdir("public/api/#{path}/#{material.id}")
      File.binwrite("public/api/#{material.image_url}", Base64.decode64(params[:image_select]))
    end
end
