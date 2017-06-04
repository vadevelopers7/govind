class Admin::ItemsController < ApplicationController
  # before_filter :authenticate_token_user!

  def index_by_category
    render json: {items:JSON.parse(Item.of_category(params[:category_id]).to_json(except: [:category_id, :created_at, :updated_at]))}, status: :ok
  end

  def index_by_retailer
    render json: {items:JSON.parse(Item.of_retailer(params[:user_id]).to_json(except: [:user_id, :created_at, :updated_at]))}, status: :ok
  end

  def show
    begin
      render json: {item:JSON.parse(Item.find(params[:id]).to_json(except: [:created_at, :updated_at]))}, status: :ok
    rescue => e
      render :json => {error: e.message}, :status => :unprocessable_entity
    end
  end

  def create
    begin
      Item.transaction do
        render :json => {item: JSON.parse(Item.create!(item_params).to_json(except: [:meta_title, :meta_keyword, :meta_description, :average_rating, :review_count, :created_at, :updated_at]))}, :status => :ok
      end
    rescue => e
      render :json => {error: e.message}, :status => :unprocessable_entity
    end
  end

  private
  def item_params
    params.require(:item).permit(:category_id, :user_id, :name, :model_no, :price, :discount, :color, :display_stock_out, :active, :inventory, :description, :image_0, :image_1, :image_2, :meta_title, :meta_keyword, :meta_description, :average_rating, :review_count)
  end
end
