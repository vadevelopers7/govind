class Admin::CategoriesController < ApplicationController
  def index_by_city
    render json: {categories:JSON.parse(Category.of_city(params[:city_id]).to_json(only: [:id, :sequence_id, :name, :active]))}, status: :ok
  end

  def show
    begin
      render json: {category:JSON.parse(Category.find(params[:id]).to_json(except: [:created_at, :updated_at]))}, status: :ok
    rescue => e
      render :json => {error: e.message}, :status => :unprocessable_entity
    end
  end

  def create
    begin
      Category.transaction do
        render :json => {category: JSON.parse(Category.create!(category_params).to_json(except: [:created_at, :updated_at]))}, :status => :ok
      end
    rescue => e
      render :json => {error: e.message}, :status => :unprocessable_entity
    end
  end

  def update
    begin
      category = Category.find(params[:id])
      Category.transaction do
        category.update!(category_params)
        render :json => {category: JSON.parse(category.to_json(except: [:created_at, :updated_at]))}, :status => :ok
      end
    rescue => e
      render :json => {error: e.message}, :status => :unprocessable_entity
    end
  end

  def destroy
    begin
      category = Category.find(params[:id])
      Category.transaction do
        category.destroy!
        render json: {}, :status => :ok
      end
    rescue => e
      render :json => {error: e.message}, :status => :unprocessable_entity
    end
  end

  private
  def category_params
    params.require(:category).permit(:city_id, :sequence_id, :name, :icon, :description, :display_home_status, :meta_title, :meta_keyword, :meta_description, :active)
  end
end
