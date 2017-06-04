class Admin::ItemsController < ApplicationController
  # before_filter :authenticate_token_user!

  def index_by_category
    render json: {items:JSON.parse(Item.of_category(params[:category_id]).to_json(except: [:category_id, :created_at, :updated_at]))}, status: :ok
  end

  def index_by_retailer
    render json: {items:JSON.parse(Item.of_retailer(params[:user_id]).to_json(except: [:user_id, :created_at, :updated_at]))}, status: :ok
  end

  private
  def address_params
    params.require(:address).permit(:user_address, :city_name, :zipcode, :user_id, :name, :phone, :city_id)
  end
end
