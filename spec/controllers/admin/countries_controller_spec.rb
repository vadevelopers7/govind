require 'rails_helper'

RSpec.describe Admin::CountriesController, type: :controller do

  describe "index" do
    context "list of all countries" do
      it "should render all countries without created_at & updated_at" do
        country = FactoryGirl.create(:country)
        get :index
        expect(JSON.parse(response.body)["countries"][0]).to eq("id" => country.id, "name" => country.name, "code" => country.code, "active" => country.active)
        expect(response).to be_ok
      end
    end
  end

  describe "show" do
    before(:each) do
      @country = FactoryGirl.create(:country)
    end
    context "with valid params" do
      it "should render a specific country detail" do
        get :show, id: @country.id
        expect(JSON.parse(response.body)["country"]).to eq("id" => @country.id, "name" => @country.name, "code" => @country.code, "active" => @country.active)
        expect(response).to be_ok
      end
    end
    context "with invalid params" do
      it "should not render country details" do
        get :show, id: @country.id+1
        expect(JSON.parse(response.body)).to eq("error"=>"Couldn't find Country with 'id'=#{@country.id+1}")
        expect(response.status).to be 422
      end
    end
  end

  describe "create" do
    context "with valid params" do
      it "should create country" do
        post :create, country: FactoryGirl.attributes_for(:country)
        expect(JSON.parse(response.body)["country"].keys).to contain_exactly("id", "name", "code", "active")
        expect(response).to be_ok
      end
      it "should increase Country table count by one" do
        expect{
          post :create, country: FactoryGirl.attributes_for(:country)
        }.to change(Country, :count).by(1)
      end
    end
    context "with invalid params" do
      it "should not create country" do
        post :create, country: FactoryGirl.attributes_for(:country, name: nil)
        expect(response.status).to be 422
      end
      it "should not increase Country table count by one" do
        expect{
          post :create, country: FactoryGirl.attributes_for(:country, code: nil)
        }.to change(Country, :count).by(0)
      end
    end
  end

  describe "update" do
    before(:each) do
      @country = FactoryGirl.create(:country)
    end
    context "with valid params" do
      it "should update country" do
        put :update, id: @country.id, country: {name: "USA"}
        @country.reload
        expect(@country.name).to eq("USA")
        expect(response).to be_ok
      end
    end
    context "with invalid params" do
      it "should not update country" do
        put :update, id: @country.id, country: {name: "USA", code: nil}
        @country.reload
        expect(@country.name).to eq("India")
        expect(response.status).to be 422
      end
    end
  end

  describe "destroy" do
    before(:each) do
      @country = FactoryGirl.create(:country)
    end
    context "with valid params" do
      it "should destroy country" do
        delete :destroy, id: @country.id
        expect(response).to be_ok
      end
      it "should decrease Country table count by one" do
        expect{
          delete :destroy, id: @country.id
        }.to change(Country, :count).by(-1)
      end
    end
    context "with invalid params" do
      it "should not destroy country" do
        delete :destroy, id: @country.id+1
        expect(response.status).to be 422
      end
      it "should not decrease Country table count by one" do
        expect{
          delete :destroy, id: @country.id+1
        }.to change(Country, :count).by(0)
      end
    end
  end
end
