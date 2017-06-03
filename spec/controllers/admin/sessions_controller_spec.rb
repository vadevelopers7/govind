require 'rails_helper'
require 'devise'
RSpec.describe Admin::SessionsController, type: :controller do
  RSpec.configure do |config|
    config.include Devise::Test::ControllerHelpers, :type => :controller
  end
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  context "POST login" do
    context "success" do
      it "should login a new admin" do
        user = FactoryGirl.create(:user, role: "admin")
        client = {push_token: "123", platform: "web"}
        post :login, user: {:email=>user.email, :password=> user.password, client: client}
        expect(DeviseMultipleTokenAuthDevice.last.platform).to eq client[:platform]
        expect(DeviseMultipleTokenAuthDevice.last.push_token).to eq client[:push_token]
        expect(DeviseMultipleTokenAuthDevice.last.user_id).to eq user.id
        auth_token = DeviseMultipleTokenAuthDevice.last.auth_token
        expect(JSON.parse(response.body)).to eq("user"=>JSON.parse(user.to_json(:except => [:created_at, :updated_at, :role, :archive, :active])).merge("auth_token"=>auth_token))
        expect(JSON.parse(response.body)["user"].keys).to contain_exactly("id", "first_name", "last_name", "mobile", "username", "email", "auth_token")
        expect(response).to be_ok
      end
    end
    context "failure" do
      it "should not login a new admin without client" do
        user = FactoryGirl.create(:user, role: "admin")
        post :login, user: {:email=>user.email, :password=> user.password}
        expect(DeviseMultipleTokenAuthDevice.last.platform).to eq(nil)
        expect(DeviseMultipleTokenAuthDevice.last.push_token).to eq(nil)
        expect(JSON.parse(response.body)).to eq("error"=>"Unable to process your request.")
        expect(response.status).to be 422
      end
      it "should return 401 if user role is not admin" do
        user = FactoryGirl.create(:user, role: "shopper")
        client = {push_token: "123", platform: "web"}
        post :login, user: {:email=>user.email, :password=> user.password, client: client}
        expect(response.status).to eq 401
      end
      it "should return 401 if params are sending in wrong fromat" do
        user = FactoryGirl.create(:user, role: "admin")
        client = {push_token: "123", platform: "web"}
        post :login, :email=>user.email, :password => user.password, client: client
        expect(response.status).to eq 401
      end
      it "should return 401 if user credentials are invalid" do
        post :login, user: {:email=>'foo@bar.com', :password=> 'foo@1234'}
        expect(response.status).to eq 401
      end
    end
  end
  context "DELETE logout" do
    context "success" do
      it "should logout the admin" do
        user = FactoryGirl.create(:user, role: "admin")
        client = {push_token: "123", platform: "web"}
        post :login, user: {:email=>user.email, :password=> user.password, client: client}
        auth_token = JSON.parse(response.body)['user']['auth_token']
        @request.env['HTTP_AUTHORIZATION'] = auth_token
        delete :logout
        expect(response).to be_ok
      end
    end
    context "failure" do
      it "should return 401 if the user is not admin" do
        @admin = FactoryGirl.create(:user, :role => 'shopper')
        @request.env["devise.mapping"] = Devise.mappings[:user]
        @request.env['HTTP_AUTHORIZATION']= @admin.create_device.auth_token
        delete :logout
        expect(response.status).to eq 401
      end
      it "should return 401 if auth_token in invalid" do
        user = FactoryGirl.create(:user, role: "admin")
        client = {push_token: "123", platform: "web"}
        post :login, user: {:email=>user.email, :password=> user.password, client: client}
        auth_token = JSON.parse(response.body)['user']['auth_token']
        @request.env['HTTP_AUTHORIZATION'] = auth_token+"123"
        delete :logout
        expect(response.status).to eq 401
      end
    end

  end
end
