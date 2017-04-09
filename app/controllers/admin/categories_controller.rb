class Admin::CategoriesController < ApplicationController
  def index_by_sub_main_category
    render json: {categories:JSON.parse(Category.of_sub_main_category(params[:sub_main_category_id]).to_json(only: [:id, :sequence_id, :name, :display_home_status, :active]))}, status: :ok
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
        render :json => {category: JSON.parse(Category.create!(category_params).to_json(only: [:id, :sequence_id, :name, :display_home_status, :active]))}, :status => :ok
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
        render :json => {category: JSON.parse(category.to_json(only: [:id, :sequence_id, :name, :display_home_status, :active]))}, :status => :ok
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
    params.require(:category).permit(:sub_main_category_id, :sequence_id, :name, :description, :display_home_status, :meta_title, :meta_keyword, :meta_description, :active)
  end
end
