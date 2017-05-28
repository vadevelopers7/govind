class Admin::SessionsController < ApplicationController
  before_filter :authenticate_token_user!, except: :login

  def login
    begin
      ActiveRecord::Base.transaction do
        email = params[:user]["email"]
        user = User.where("username = ? or email = ?",email, email).first
        if user.present? && user.valid_password?(params[:user]["password"]) && user.role == "admin"
          device = user.create_device
          client = params["user"]["client"]
          if client && client[:platform].strip != "" && client[:push_token].strip != ""
            device.update(:platform=>client[:platform],:push_token=>client[:push_token])
            render json: {user: JSON::parse(user.to_json(:except => [:created_at, :updated_at, :role])).merge(auth_token: device.auth_token)}, status: :ok
          else
            render json: {error: "Unable to process your request."}, status: :unprocessable_entity
          end
        else
          render json: {error: 'Invalid credentials'}, status: :unauthorized
        end
      end
    rescue => e
      render json: {error: e.message}, status: :unauthorized
    end
  end
end
