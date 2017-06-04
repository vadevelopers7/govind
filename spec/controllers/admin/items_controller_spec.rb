require 'rails_helper'

RSpec.describe Admin::ItemsController, type: :controller do
  RSpec.configure do |config|
    config.include Devise::Test::ControllerHelpers, type: :controller
  end
  before(:each) do
    country = FactoryGirl.create(:country)
    state = FactoryGirl.create(:state, country_id: country.id)
    city = FactoryGirl.create(:city, state_id: state.id)
    main_category = FactoryGirl.create(:main_category, city_id: city.id)
    sub_main_category = FactoryGirl.create(:sub_main_category, main_category_id: main_category.id)
    @category = FactoryGirl.create(:category, sub_main_category_id: sub_main_category.id)
  end

  describe "index_by_category" do
    context "valid params" do
      it "should render all items of a category" do
        item = FactoryGirl.create(:item, category_id: @category.id)
        get :index_by_category, category_id: item.category_id
        expect(JSON.parse(response.body)["items"][0]).to eq("id" => item.id, "user_id" => item.user_id, "name" => item.name, "model_no" => item.model_no, "price" => item.price.to_s, "discount" => item.discount.to_s, "color" => item.color, "display_stock_out" => item.display_stock_out, "active" => item.active, "inventory" => item.inventory, "description" => item.description, "image_0" => item.image_0, "image_1" => item.image_1, "image_2" => item.image_2, "meta_title" => item.meta_title, "meta_keyword" => item.meta_keyword, "meta_description" => item.meta_description, "average_rating" => item.average_rating.to_s, "review_count" => item.review_count)
        expect(response).to be_ok
      end
    end
    context "invalid params" do
      it "should not render any list of items if category id invalid" do
        get :index_by_category, category_id: 1
        expect(JSON.parse(response.body)["items"]).to eq([])
        expect(response).to be_ok
      end
    end
  end
  describe "index_by_retailer" do
    context "valid params" do
      it "should render all items of a retailer" do
        retailer = FactoryGirl.create(:user, :role => 'retailer')
        item = FactoryGirl.create(:item, user_id: retailer.id)
        get :index_by_retailer, user_id: item.user_id
        expect(JSON.parse(response.body)["items"][0]).to eq("id" => item.id, "category_id" => item.category_id, "name" => item.name, "model_no" => item.model_no, "price" => item.price.to_s, "discount" => item.discount.to_s, "color" => item.color, "display_stock_out" => item.display_stock_out, "active" => item.active, "inventory" => item.inventory, "description" => item.description, "image_0" => item.image_0, "image_1" => item.image_1, "image_2" => item.image_2, "meta_title" => item.meta_title, "meta_keyword" => item.meta_keyword, "meta_description" => item.meta_description, "average_rating" => item.average_rating.to_s, "review_count" => item.review_count)
        expect(response).to be_ok
      end
    end
    context "invalid params" do
      it "should not render any list of items if user (retailer) id invalid" do
        get :index_by_retailer, user_id: 1
        expect(JSON.parse(response.body)["items"]).to eq([])
        expect(response).to be_ok
      end
    end
  end
  describe "show" do
    before(:each) do
      @item = FactoryGirl.create(:item, category_id: @category.id)
    end
    context "with valid params" do
      it "should render a specific item detail" do
        get :show, id: @item.id
        expect(JSON.parse(response.body)["item"]).to eq("id" => @item.id, "user_id" => @item.user_id, "category_id" => @item.category_id, "name" => @item.name, "model_no" => @item.model_no, "price" => @item.price.to_s, "discount" => @item.discount.to_s, "color" => @item.color, "display_stock_out" => @item.display_stock_out, "active" => @item.active, "inventory" => @item.inventory, "description" => @item.description, "image_0" => @item.image_0, "image_1" => @item.image_1, "image_2" => @item.image_2, "meta_title" => @item.meta_title, "meta_keyword" => @item.meta_keyword, "meta_description" => @item.meta_description, "average_rating" => @item.average_rating.to_s, "review_count" => @item.review_count)
        expect(response).to be_ok
      end
    end
    context "with invalid params" do
      it "should not render item details" do
        get :show, id: @item.id+1
        expect(JSON.parse(response.body)).to eq("error"=>"Couldn't find Item with 'id'=#{@item.id+1}")
        expect(response.status).to be 422
      end
    end
  end
  describe "create" do
    context "with valid params" do
      it "should create item" do
        user = FactoryGirl.create(:user, role: "retailer")
        post :create, item: FactoryGirl.attributes_for(:item, user_id: user.id, category_id: @category.id)
        expect(JSON.parse(response.body)["item"].keys).to contain_exactly("id", "category_id", "user_id", "name", "model_no", "price", "discount", "color", "display_stock_out", "active", "inventory", "description", "image_0", "image_1", "image_2")
        expect(response).to be_ok
      end
      it "should increase Item table count by one" do
        user = FactoryGirl.create(:user, role: "retailer")
        expect{
          post :create, item: FactoryGirl.attributes_for(:item, user_id: user.id, category_id: @category.id)
        }.to change(Item, :count).by(1)
      end
    end
    context "with invalid params" do
      it "should not create item if item name is nil" do
        user = FactoryGirl.create(:user, role: "retailer")
        post :create, item: FactoryGirl.attributes_for(:item, user_id: user.id, category_id: @category.id, name: nil)
        expect(response.status).to be 422
      end
      it "should not increase Item table count by one" do
        user = FactoryGirl.create(:user, role: "retailer")
        expect{
          post :create, item: FactoryGirl.attributes_for(:item, user_id: user.id, category_id: @category.id, name: nil)
        }.to change(Item, :count).by(0)
      end
    end
  end

end
