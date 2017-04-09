require 'rails_helper'

RSpec.describe Admin::CategoriesController, type: :controller do
  before(:each) do
    country = FactoryGirl.create(:country)
    state = FactoryGirl.create(:state, country_id: country.id)
    city = FactoryGirl.create(:city, state_id: state.id)
    main_category = FactoryGirl.create(:main_category, city_id: city.id)
    @sub_main_category = FactoryGirl.create(:sub_main_category, main_category_id: main_category.id)
  end

  describe "index_by_sub_main_category" do
    context "valid params" do
      it "should render all categories of a sub_main_category" do
        category = FactoryGirl.create(:category, sub_main_category_id: @sub_main_category.id)
        get :index_by_sub_main_category, sub_main_category_id: category.sub_main_category_id
        expect(JSON.parse(response.body)["categories"][0]).to eq("id" => category.id, "sequence_id" => category.sequence_id, "name" => category.name, "display_home_status" => category.display_home_status, "active" => category.active)
        expect(response).to be_ok
      end
    end
    context "invalid params" do
      it "should not render any category if sub_main_category id invalid" do
        get :index_by_sub_main_category, sub_main_category_id: 1
        expect(JSON.parse(response.body)["categories"]).to eq([])
        expect(response).to be_ok
      end
    end
  end

  describe "show" do
    before(:each) do
      @category = FactoryGirl.create(:category, sub_main_category_id: @sub_main_category.id)
    end
    context "with valid params" do
      it "should render a specific category detail" do
        get :show, id: @category.id
        expect(JSON.parse(response.body)["category"]).to eq("id" => @category.id, "sub_main_category_id" => @category.sub_main_category_id, "sequence_id" => @category.sequence_id, "name" => @category.name, "description" => @category.description, "display_home_status" => @category.display_home_status, "meta_title" => @category.meta_title, "meta_keyword" => @category.meta_keyword, "meta_description" => @category.meta_description, "active" => @category.active)
        expect(response).to be_ok
      end
    end
    context "with invalid params" do
      it "should not render category details" do
        get :show, id: @category.id+1
        expect(JSON.parse(response.body)).to eq("error"=>"Couldn't find Category with 'id'=#{@category.id+1}")
        expect(response.status).to be 422
      end
    end
  end

  describe "create" do
    context "with valid params" do
      it "should create category" do
        post :create, category: FactoryGirl.attributes_for(:category, sub_main_category_id: @sub_main_category.id)
        expect(JSON.parse(response.body)["category"].keys).to contain_exactly("id", "sequence_id", "name", "display_home_status", "active")
        expect(response).to be_ok
      end
      it "should increase Category table count by one" do
        expect{
          post :create, category: FactoryGirl.attributes_for(:category, sub_main_category_id: @sub_main_category.id)
        }.to change(Category, :count).by(1)
      end
    end
    context "with invalid params" do
      it "should not create category" do
        post :create, category: FactoryGirl.attributes_for(:category, sub_main_category_id: @sub_main_category.id, name: nil)
        expect(response.status).to be 422
      end
      it "should not increase Category table count by one" do
        expect{
          post :create, category: FactoryGirl.attributes_for(:category, sub_main_category_id: @sub_main_category.id, sequence_id: nil)
        }.to change(Category, :count).by(0)
      end
    end
  end

  describe "update" do
    before(:each) do
      @category = FactoryGirl.create(:category, sub_main_category_id: @sub_main_category.id, name: "XYZ")
    end
    context "with valid params" do
      it "should update category" do
        put :update, id: @category.id, category: {name: "ABC"}
        @category.reload
        expect(@category.name).to eq("ABC")
        expect(response).to be_ok
      end
    end
    context "with invalid params" do
      it "should not update category" do
        put :update, id: @category.id, category: {name: "ABC", sequence_id: nil}
        @category.reload
        expect(@category.name).to eq("XYZ")
        expect(response.status).to be 422
      end
    end
  end

  describe "destroy" do
    before(:each) do
      @category = FactoryGirl.create(:category, sub_main_category_id: @sub_main_category.id)
    end
    context "with valid params" do
      it "should destroy category" do
        delete :destroy, id: @category.id
        expect(response).to be_ok
      end
      it "should decrease Category table count by one" do
        expect{
          delete :destroy, id: @category.id
        }.to change(Category, :count).by(-1)
      end
    end
    context "with invalid params" do
      it "should not destroy category" do
        delete :destroy, id: @category.id+1
        expect(response.status).to be 422
      end
      it "should not decrease Category table count by one" do
        expect{
          delete :destroy, id: @category.id+1
        }.to change(Category, :count).by(0)
      end
    end
  end
end
