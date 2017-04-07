require 'rails_helper'

RSpec.describe Admin::StatesController, type: :controller do

  before(:each) do
    @country = FactoryGirl.create(:country)
  end

  describe "index_by_country" do
    context "valid params" do
      it "should render all states of a country" do
        state = FactoryGirl.create(:state, country_id: @country.id)
        get :index_by_country, country_id: state.country_id
        expect(JSON.parse(response.body)["states"][0]).to eq("id" => state.id, "country_id" => state.country_id, "name" => state.name, "code" => state.code, "active" => state.active)
        expect(response).to be_ok
      end
    end
    context "invalid params" do
      it "should not render any state if country id invalid" do
        get :index_by_country, country_id: 1
        expect(JSON.parse(response.body)["states"]).to eq([])
        expect(response).to be_ok
      end
    end
  end

  describe "show" do
    before(:each) do
      @state = FactoryGirl.create(:state, country_id: @country.id)
    end
    context "with valid params" do
      it "should render a specific state detail" do
        get :show, id: @state.id
        expect(JSON.parse(response.body)["state"]).to eq("id" => @state.id, "country_id" => @state.country_id, "name" => @state.name, "code" => @state.code, "active" => @state.active)
        expect(response).to be_ok
      end
    end
    context "with invalid params" do
      it "should not render state details" do
        get :show, id: @state.id+1
        expect(JSON.parse(response.body)).to eq("error"=>"Couldn't find State with 'id'=#{@state.id+1}")
        expect(response.status).to be 422
      end
    end
  end

  describe "create" do
    context "with valid params" do
      it "should create state" do
        post :create, state: FactoryGirl.attributes_for(:state, country_id: @country.id)
        expect(JSON.parse(response.body)["state"].keys).to contain_exactly("id", "country_id", "name", "code", "active")
        expect(response).to be_ok
      end
      it "should increase State table count by one" do
        expect{
          post :create, state: FactoryGirl.attributes_for(:state, country_id: @country.id)
        }.to change(State, :count).by(1)
      end
    end
    context "with invalid params" do
      it "should not create state" do
        post :create, state: FactoryGirl.attributes_for(:state, country_id: @country.id, name: nil)
        expect(response.status).to be 422
      end
      it "should not increase State table count by one" do
        expect{
          post :create, state: FactoryGirl.attributes_for(:state, country_id: @country.id, code: nil)
        }.to change(State, :count).by(0)
      end
    end
  end

  describe "update" do
    before(:each) do
      @state = FactoryGirl.create(:state, country_id: @country.id)
    end
    context "with valid params" do
      it "should update state" do
        put :update, id: @state.id, state: {name: "Jaipur"}
        @state.reload
        expect(@state.name).to eq("Jaipur")
        expect(response).to be_ok
      end
    end
    context "with invalid params" do
      it "should not update state" do
        put :update, id: @state.id, state: {name: "Jaipur", code: nil}
        @state.reload
        expect(@state.name).to eq("Rajasthan")
        expect(response.status).to be 422
      end
    end
  end

  describe "destroy" do
    before(:each) do
      @state = FactoryGirl.create(:state, country_id: @country.id)
    end
    context "with valid params" do
      it "should destroy state" do
        delete :destroy, id: @state.id
        expect(response).to be_ok
      end
      it "should decrease State table count by one" do
        expect{
          delete :destroy, id: @state.id
        }.to change(State, :count).by(-1)
      end
    end
    context "with invalid params" do
      it "should not destroy state" do
        delete :destroy, id: @state.id+1
        expect(response.status).to be 422
      end
      it "should not decrease State table count by one" do
        expect{
          delete :destroy, id: @state.id+1
        }.to change(State, :count).by(0)
      end
    end
  end
end
