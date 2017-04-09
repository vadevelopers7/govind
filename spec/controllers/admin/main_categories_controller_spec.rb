require 'rails_helper'

RSpec.describe Admin::MainCategoriesController, type: :controller do
  before(:each) do
    country = FactoryGirl.create(:country)
    state = FactoryGirl.create(:state, country_id: country.id)
    @city = FactoryGirl.create(:city, state_id: state.id)
  end

  describe "index_by_city" do
    context "valid params" do
      it "should render all main_categories of a city" do
        main_category = FactoryGirl.create(:main_category, city_id: @city.id)
        get :index_by_city, city_id: main_category.city_id
        expect(JSON.parse(response.body)["main_categories"][0]).to eq("id" => main_category.id, "sequence_id" => main_category.sequence_id, "name" => main_category.name, "active" => main_category.active, "icon" => main_category.icon, "display_home_status" => main_category.display_home_status)
        expect(response).to be_ok
      end
    end
    context "invalid params" do
      it "should not render any main_category if city id invalid" do
        get :index_by_city, city_id: 1
        expect(JSON.parse(response.body)["main_categories"]).to eq([])
        expect(response).to be_ok
      end
    end
  end

  describe "show" do
    before(:each) do
      @main_category = FactoryGirl.create(:main_category, city_id: @city.id)
    end
    context "with valid params" do
      it "should render a specific main_category detail" do
        get :show, id: @main_category.id
        expect(JSON.parse(response.body)["main_category"]).to eq("id" => @main_category.id, "city_id" => @main_category.city_id, "sequence_id" => @main_category.sequence_id, "name" => @main_category.name, "icon" => @main_category.icon, "display_home_status" => @main_category.display_home_status, "active" => @main_category.active)
        expect(response).to be_ok
      end
    end
    context "with invalid params" do
      it "should not render main_category details" do
        get :show, id: @main_category.id+1
        expect(JSON.parse(response.body)).to eq("error"=>"Couldn't find MainCategory with 'id'=#{@main_category.id+1}")
        expect(response.status).to be 422
      end
    end
  end

  describe "create" do
    context "with valid params" do
      it "should create main_category" do
        post :create, main_category: FactoryGirl.attributes_for(:main_category, city_id: @city.id)
        expect(JSON.parse(response.body)["main_category"].keys).to contain_exactly("id", "sequence_id", "name", "active", "icon", "display_home_status")
        expect(response).to be_ok
      end
      it "should increase MainCategory table count by one" do
        expect{
          post :create, main_category: FactoryGirl.attributes_for(:main_category, city_id: @city.id)
        }.to change(MainCategory, :count).by(1)
      end
    end
    context "with invalid params" do
      it "should not create main_category" do
        post :create, main_category: FactoryGirl.attributes_for(:main_category, city_id: @city.id, name: nil)
        expect(response.status).to be 422
      end
      it "should not increase MainCategory table count by one" do
        expect{
          post :create, main_category: FactoryGirl.attributes_for(:main_category, city_id: @city.id, sequence_id: nil)
        }.to change(MainCategory, :count).by(0)
      end
    end
  end

  describe "update" do
    before(:each) do
      @main_category = FactoryGirl.create(:main_category, city_id: @city.id, name: "XYZ")
    end
    context "with valid params" do
      it "should update main_category" do
        put :update, id: @main_category.id, main_category: {name: "ABC"}
        @main_category.reload
        expect(@main_category.name).to eq("ABC")
        expect(response).to be_ok
      end
    end
    context "with invalid params" do
      it "should not update main_category" do
        put :update, id: @main_category.id, main_category: {name: "ABC", sequence_id: nil}
        @main_category.reload
        expect(@main_category.name).to eq("XYZ")
        expect(response.status).to be 422
      end
    end
  end

  describe "destroy" do
    before(:each) do
      @main_category = FactoryGirl.create(:main_category, city_id: @city.id)
    end
    context "with valid params" do
      it "should destroy main_category" do
        delete :destroy, id: @main_category.id
        expect(response).to be_ok
      end
      it "should decrease MainCategory table count by one" do
        expect{
          delete :destroy, id: @main_category.id
        }.to change(MainCategory, :count).by(-1)
      end
    end
    context "with invalid params" do
      it "should not destroy main_category" do
        delete :destroy, id: @main_category.id+1
        expect(response.status).to be 422
      end
      it "should not decrease MainCategory table count by one" do
        expect{
          delete :destroy, id: @main_category.id+1
        }.to change(MainCategory, :count).by(0)
      end
    end
  end
end
