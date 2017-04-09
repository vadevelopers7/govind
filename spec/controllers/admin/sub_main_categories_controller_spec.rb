require 'rails_helper'

RSpec.describe Admin::SubMainCategoriesController, type: :controller do
  before(:each) do
    country = FactoryGirl.create(:country)
    state = FactoryGirl.create(:state, country_id: country.id)
    city = FactoryGirl.create(:city, state_id: state.id)
    @main_category = FactoryGirl.create(:main_category, city_id: city.id)
  end

  describe "index_by_main_category" do
    context "valid params" do
      it "should render all sub_main_categories of a city" do
        sub_main_category = FactoryGirl.create(:sub_main_category, main_category_id: @main_category.id)
        get :index_by_main_category, main_category_id: sub_main_category.main_category_id
        expect(JSON.parse(response.body)["sub_main_categories"][0]).to eq("id" => sub_main_category.id, "sequence_id" => sub_main_category.sequence_id, "name" => sub_main_category.name, "active" => sub_main_category.active)
        expect(JSON.parse(response.body)["sub_main_categories"][0].keys).to contain_exactly("id", "sequence_id", "name", "active")
        expect(response).to be_ok
      end
    end
    context "invalid params" do
      it "should not render any sub_main_category if city id invalid" do
        get :index_by_main_category, main_category_id: 1
        expect(JSON.parse(response.body)["sub_main_categories"]).to eq([])
        expect(response).to be_ok
      end
    end
  end

  describe "show" do
    before(:each) do
      @sub_main_category = FactoryGirl.create(:sub_main_category, main_category_id: @main_category.id)
    end
    context "with valid params" do
      it "should render a specific sub_main_category detail" do
        get :show, id: @sub_main_category.id
        expect(JSON.parse(response.body)["sub_main_category"]).to eq("id" => @sub_main_category.id, "main_category_id" => @sub_main_category.main_category_id, "sequence_id" => @sub_main_category.sequence_id, "name" => @sub_main_category.name, "active" => @sub_main_category.active)
        expect(JSON.parse(response.body)["sub_main_category"].keys).to contain_exactly("id", "main_category_id", "sequence_id", "name", "active")
        expect(response).to be_ok
      end
    end
    context "with invalid params" do
      it "should not render sub_main_category details" do
        get :show, id: @sub_main_category.id+1
        expect(JSON.parse(response.body)).to eq("error"=>"Couldn't find SubMainCategory with 'id'=#{@sub_main_category.id+1}")
        expect(response.status).to be 422
      end
    end
  end

  describe "create" do
    context "with valid params" do
      it "should create sub_main_category" do
        post :create, sub_main_category: FactoryGirl.attributes_for(:sub_main_category, main_category_id: @main_category.id)
        expect(JSON.parse(response.body)["sub_main_category"].keys).to contain_exactly("id", "sequence_id", "name", "active")
        expect(response).to be_ok
      end
      it "should increase SubMainCategory table count by one" do
        expect{
          post :create, sub_main_category: FactoryGirl.attributes_for(:sub_main_category, main_category_id: @main_category.id)
        }.to change(SubMainCategory, :count).by(1)
      end
    end
    context "with invalid params" do
      it "should not create sub_main_category" do
        post :create, sub_main_category: FactoryGirl.attributes_for(:sub_main_category, main_category_id: @main_category.id, name: nil)
        expect(response.status).to be 422
      end
      it "should not increase SubMainCategory table count by one" do
        expect{
          post :create, sub_main_category: FactoryGirl.attributes_for(:sub_main_category, main_category_id: @main_category.id, sequence_id: nil)
        }.to change(SubMainCategory, :count).by(0)
      end
    end
  end

  describe "update" do
    before(:each) do
      @sub_main_category = FactoryGirl.create(:sub_main_category, main_category_id: @main_category.id, name: "XYZ")
    end
    context "with valid params" do
      it "should update sub_main_category" do
        put :update, id: @sub_main_category.id, sub_main_category: {name: "ABC"}
        @sub_main_category.reload
        expect(@sub_main_category.name).to eq("ABC")
        expect(response).to be_ok
      end
    end
    context "with invalid params" do
      it "should not update sub_main_category" do
        put :update, id: @sub_main_category.id, sub_main_category: {name: "ABC", sequence_id: nil}
        @sub_main_category.reload
        expect(@sub_main_category.name).to eq("XYZ")
        expect(response.status).to be 422
      end
    end
  end

  describe "destroy" do
    before(:each) do
      @sub_main_category = FactoryGirl.create(:sub_main_category, main_category_id: @main_category.id)
    end
    context "with valid params" do
      it "should destroy sub_main_category" do
        delete :destroy, id: @sub_main_category.id
        expect(response).to be_ok
      end
      it "should decrease SubMainCategory table count by one" do
        expect{
          delete :destroy, id: @sub_main_category.id
        }.to change(SubMainCategory, :count).by(-1)
      end
    end
    context "with invalid params" do
      it "should not destroy sub_main_category" do
        delete :destroy, id: @sub_main_category.id+1
        expect(response.status).to be 422
      end
      it "should not decrease SubMainCategory table count by one" do
        expect{
          delete :destroy, id: @sub_main_category.id+1
        }.to change(SubMainCategory, :count).by(0)
      end
    end
  end
end
