class Admin::RegistrationsController < Devise::RegistrationsController

  before_filter :authenticate_token_user!
  skip_before_action :authenticate_scope! ,only:[:update]
  skip_filter :authenticate_token_user!, only: [:create]

  def create
    begin
      ActiveRecord::Base.transaction do
        @user = User.new(JSON.parse(user_params.to_json(except: :client)))
        if @user.is_admin?
          @user.save!
          @user_create = true
        else
          render :json =>{:error => "Unable to process your request."}, :status => :unauthorized
        end
        if @user_create
          device = @user.create_device
          if user_params["client"] && user_params["client"][:platform] && user_params["client"][:push_token]
            device.update(:platform=>user_params["client"][:platform],:push_token=>user_params["client"][:push_token])
          end
          render :json =>{user: JSON.parse(@user.to_json(except: [:created_at, :updated_at])).merge(auth_token: device.auth_token)}, :status => :ok
        end
      end
    rescue => e
      render :json =>{:error => e.message}, :status => :unprocessable_entity
    end
  end

  def update
    begin
      @user = User.find(current_user.id)
      if @user.is_admin?
        @user.update!(user_params)
        render :json =>@user, :status => :ok
      else
        render :json =>{:error => "Unable to process your request."}, :status => :unauthorized
      end
    rescue => e
      render :json =>{:error => e.message}, :status => :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :email, :mobile, :password, :role, client: [:push_token, :platform])
  end

end
