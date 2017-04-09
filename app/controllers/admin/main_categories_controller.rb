class Admin::MainCategoriesController < ApplicationController
  def index_by_city
    render json: {main_categories:JSON.parse(MainCategory.of_city(params[:city_id]).to_json(except: [:city_id, :created_at, :updated_at]))}, status: :ok
  end

  def show
    begin
      render json: {main_category:JSON.parse(MainCategory.find(params[:id]).to_json(except: [:created_at, :updated_at]))}, status: :ok
    rescue => e
      render :json => {error: e.message}, :status => :unprocessable_entity
    end
  end

  def create
    begin
      MainCategory.transaction do
        render :json => {main_category: JSON.parse(MainCategory.create!(main_category_params).to_json(except: [:city_id, :created_at, :updated_at]))}, :status => :ok
      end
    rescue => e
      render :json => {error: e.message}, :status => :unprocessable_entity
    end
  end

  def update
    begin
      main_category = MainCategory.find(params[:id])
      MainCategory.transaction do
        main_category.update!(main_category_params)
        render :json => {main_category: JSON.parse(main_category.to_json(except: [:city_id, :created_at, :updated_at]))}, :status => :ok
      end
    rescue => e
      render :json => {error: e.message}, :status => :unprocessable_entity
    end
  end

  def destroy
    begin
      main_category = MainCategory.find(params[:id])
      MainCategory.transaction do
        main_category.destroy!
        render json: {}, :status => :ok
      end
    rescue => e
      render :json => {error: e.message}, :status => :unprocessable_entity
    end
  end

  private
  def main_category_params
    params.require(:main_category).permit(:city_id, :sequence_id, :name, :icon, :display_home_status, :active)
  end
end
