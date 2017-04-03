class Admin::StatesController < ApplicationController
  def index
    render json: {states:JSON.parse(State.all.to_json(except: [:created_at, :updated_at]))}, status: :ok
  end

  def show
    begin
      render json: {state:JSON.parse(State.find(params[:id]).to_json(except: [:created_at, :updated_at]))}, status: :ok
    rescue => e
      render :json => {error: e.message}, :status => :unprocessable_entity
    end
  end

  def create
    begin
      State.transaction do
        render :json => {state: JSON.parse(State.create!(country_params).to_json(except: [:created_at, :updated_at]))}, :status => :ok
      end
    rescue => e
      render :json => {error: e.message}, :status => :unprocessable_entity
    end
  end

  def update
    begin
      state = State.find(params[:id])
      State.transaction do
        state.update!(country_params)
        render :json => {state: JSON.parse(state.to_json(except: [:created_at, :updated_at]))}, :status => :ok
      end
    rescue => e
      render :json => {error: e.message}, :status => :unprocessable_entity
    end
  end

  def destroy
    begin
      state = State.find(params[:id])
      State.transaction do
        state.destroy!
        render json: {}, :status => :ok
      end
    rescue => e
      render :json => {error: e.message}, :status => :unprocessable_entity
    end
  end

  private
  def country_params
    params.require(:state).permit(:name, :code, :active)
  end
end
