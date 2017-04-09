class Admin::SubMainCategoriesController < ApplicationController
  def index_by_main_category
    render json: {sub_main_categories:JSON.parse(SubMainCategory.of_main_category(params[:main_category_id]).to_json(except: [:main_category_id, :created_at, :updated_at]))}, status: :ok
  end

  def show
    begin
      render json: {sub_main_category:JSON.parse(SubMainCategory.find(params[:id]).to_json(except: [:created_at, :updated_at]))}, status: :ok
    rescue => e
      render :json => {error: e.message}, :status => :unprocessable_entity
    end
  end

  def create
    begin
      SubMainCategory.transaction do
        render :json => {sub_main_category: JSON.parse(SubMainCategory.create!(sub_main_category_params).to_json(except: [:main_category_id, :created_at, :updated_at]))}, :status => :ok
      end
    rescue => e
      render :json => {error: e.message}, :status => :unprocessable_entity
    end
  end

  def update
    begin
      sub_main_category = SubMainCategory.find(params[:id])
      SubMainCategory.transaction do
        sub_main_category.update!(sub_main_category_params)
        render :json => {sub_main_category: JSON.parse(sub_main_category.to_json(except: [:main_category_id, :created_at, :updated_at]))}, :status => :ok
      end
    rescue => e
      render :json => {error: e.message}, :status => :unprocessable_entity
    end
  end

  def destroy
    begin
      sub_main_category = SubMainCategory.find(params[:id])
      SubMainCategory.transaction do
        sub_main_category.destroy!
        render json: {}, :status => :ok
      end
    rescue => e
      render :json => {error: e.message}, :status => :unprocessable_entity
    end
  end

  private
  def sub_main_category_params
    params.require(:sub_main_category).permit(:main_category_id, :sequence_id, :name, :active)
  end
end
