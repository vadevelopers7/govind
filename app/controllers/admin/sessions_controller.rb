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
            render json: {user: JSON::parse(user.to_json(:except => [:created_at, :updated_at, :role, :archive, :active])).merge(auth_token: device.auth_token)}, status: :ok
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

  def logout
    if @device
      if @current_user.role == "admin"
        @auth_token = @device.auth_token
        @user_client = DeviseMultipleTokenAuthDevice.where(:auth_token => @auth_token).first
        # DeviseMultipleTokenAuthDevice.where(:user_id => @user_client.user_id, :platform => @user_client.platform).delete_all
        @device.destroy
        render json: {}, status: :ok
        return
      end
    end
    render json: {}, status: :unauthorized
  end
end
