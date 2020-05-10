class TeachingMaterialsController < ApplicationController
  before_action :current_user

  def index
    materials = TeachingMaterial.where(user_id: params[:user_id])
    render json: materials
  end

  def crate
    material = TeachingMaterial.new(material_params)
    material.user_id = @current_user.user_id

    if material.save
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
