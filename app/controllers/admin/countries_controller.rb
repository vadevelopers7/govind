class Admin::CountriesController < ApplicationController
  def index
    render json: {countries:JSON.parse(Country.all.to_json(except: [:created_at, :updated_at]))}, status: :ok
  end

  def show
    begin
      render json: {country:JSON.parse(Country.find(params[:id]).to_json(except: [:created_at, :updated_at]))}, status: :ok
    rescue => e
      render :json => {error: e.message}, :status => :unprocessable_entity
    end
  end

  def create
    begin
      Country.transaction do
        render :json => {country: JSON.parse(Country.create!(country_params).to_json(except: [:created_at, :updated_at]))}, :status => :ok
      end
    rescue => e
      render :json => {error: e.message}, :status => :unprocessable_entity
    end
  end

  def update
    begin
      country = Country.find(params[:id])
      Country.transaction do
        country.update!(country_params)
        render :json => {country: JSON.parse(country.to_json(except: [:created_at, :updated_at]))}, :status => :ok
      end
    rescue => e
      render :json => {error: e.message}, :status => :unprocessable_entity
    end
  end

  def destroy
    begin
      country = Country.find(params[:id])
      Country.transaction do
        country.destroy!
        render json: {}, :status => :ok
      end
    rescue => e
      render :json => {error: e.message}, :status => :unprocessable_entity
    end
  end

  private
  def country_params
    params.require(:country).permit(:name, :code, :active)
  end
end
