require 'rails_helper'

RSpec.describe Admin::CitiesController, type: :controller do

  before(:each) do
    country = FactoryGirl.create(:country)
    @state = FactoryGirl.create(:state, country_id: country.id)
  end

  describe "index_by_country" do
    context "valid params" do
      it "should render all cities of a state" do
        city = FactoryGirl.create(:city, state_id: @state.id)
        get :index_by_state, state_id: city.state_id
        expect(JSON.parse(response.body)["cities"][0]).to eq("id" => city.id, "name" => city.name, "code" => city.code, "min_shipping_charge" => city.min_shipping_charge.to_s, "active" => city.active)
        expect(response).to be_ok
      end
    end
    context "invalid params" do
      it "should not render any city if state id invalid" do
        get :index_by_state, state_id: 1
        expect(JSON.parse(response.body)["cities"]).to eq([])
        expect(response).to be_ok
      end
    end
  end

  describe "show" do
    before(:each) do
      @city = FactoryGirl.create(:city, state_id: @state.id)
    end
    context "with valid params" do
      it "should render a specific city detail" do
        get :show, id: @city.id
        expect(JSON.parse(response.body)["city"]).to eq("id" => @city.id, "state_id" => @city.state_id, "name" => @city.name, "code" => @city.code, "active" => @city.active, "min_shipping_charge" => @city.min_shipping_charge.to_s)
        expect(response).to be_ok
      end
    end
    context "with invalid params" do
      it "should not render city details" do
        get :show, id: @city.id+1
        expect(JSON.parse(response.body)).to eq("error"=>"Couldn't find City with 'id'=#{@city.id+1}")
        expect(response.status).to be 422
      end
    end
  end

  describe "create" do
    context "with valid params" do
      it "should create city" do
        post :create, city: FactoryGirl.attributes_for(:city, state_id: @state.id)
        expect(JSON.parse(response.body)["city"].keys).to contain_exactly("id", "name", "code", "active", "min_shipping_charge")
        expect(response).to be_ok
      end
      it "should increase City table count by one" do
        expect{
          post :create, city: FactoryGirl.attributes_for(:city, state_id: @state.id)
        }.to change(City, :count).by(1)
      end
    end
    context "with invalid params" do
      it "should not create city" do
        post :create, city: FactoryGirl.attributes_for(:city, state_id: @state.id, name: nil)
        expect(response.status).to be 422
      end
      it "should not increase City table count by one" do
        expect{
          post :create, city: FactoryGirl.attributes_for(:city, state_id: @state.id, code: nil)
        }.to change(City, :count).by(0)
      end
    end
  end

  describe "update" do
    before(:each) do
      @city = FactoryGirl.create(:city, state_id: @state.id)
    end
    context "with valid params" do
      it "should update city" do
        put :update, id: @city.id, city: {name: "Jaipur"}
        @city.reload
        expect(@city.name).to eq("Jaipur")
        expect(response).to be_ok
      end
    end
    context "with invalid params" do
      it "should not update city" do
        put :update, id: @city.id, city: {name: "Jaipur", code: nil}
        @city.reload
        expect(@city.name).to eq("Udaipur")
        expect(response.status).to be 422
      end
    end
  end

  describe "destroy" do
    before(:each) do
      @city = FactoryGirl.create(:city, state_id: @state.id)
    end
    context "with valid params" do
      it "should destroy city" do
        delete :destroy, id: @city.id
        expect(response).to be_ok
      end
      it "should decrease City table count by one" do
        expect{
          delete :destroy, id: @city.id
        }.to change(City, :count).by(-1)
      end
    end
    context "with invalid params" do
      it "should not destroy city" do
        delete :destroy, id: @city.id+1
        expect(response.status).to be 422
      end
      it "should not decrease City table count by one" do
        expect{
          delete :destroy, id: @city.id+1
        }.to change(City, :count).by(0)
      end
    end
  end
end
