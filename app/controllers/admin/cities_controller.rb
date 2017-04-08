class Admin::CitiesController < ApplicationController
  def index_by_state
    render json: {cities:JSON.parse(City.of_state(params[:state_id]).to_json(except: [:state_id, :created_at, :updated_at]))}, status: :ok
  end

  def show
    begin
      render json: {city:JSON.parse(City.find(params[:id]).to_json(except: [:created_at, :updated_at]))}, status: :ok
    rescue => e
      render :json => {error: e.message}, :status => :unprocessable_entity
    end
  end

  def create
    begin
      City.transaction do
        render :json => {city: JSON.parse(City.create!(city_params).to_json(except: [:state_id, :created_at, :updated_at]))}, :status => :ok
      end
    rescue => e
      render :json => {error: e.message}, :status => :unprocessable_entity
    end
  end

  def update
    begin
      city = City.find(params[:id])
      City.transaction do
        city.update!(city_params)
        render :json => {city: JSON.parse(city.to_json(except: [:state_id, :created_at, :updated_at]))}, :status => :ok
      end
    rescue => e
      render :json => {error: e.message}, :status => :unprocessable_entity
    end
  end

  def destroy
    begin
      city = City.find(params[:id])
      City.transaction do
        city.destroy!
        render json: {}, :status => :ok
      end
    rescue => e
      render :json => {error: e.message}, :status => :unprocessable_entity
    end
  end

  private
  def city_params
    params.require(:city).permit(:state_id, :name, :code, :active)
  end
end
