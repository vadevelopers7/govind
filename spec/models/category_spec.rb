require 'rails_helper'

RSpec.describe Category, type: :model do
  context 'validations'do
    ["sub_main_category_id", "sequence_id", "name"].each do |field|
      it "should be invalid if #{field} is not present"do
        expect(FactoryGirl.build(:category,"#{field}".to_sym =>nil)).not_to be_valid
      end
    end
  end

  before(:each) do
    country = FactoryGirl.create(:country)
    state = FactoryGirl.create(:state, country_id: country.id)
    city = FactoryGirl.create(:city, state_id: state.id)
    @main_category = FactoryGirl.create(:main_category, city_id: city.id)
    @sub_main_category = FactoryGirl.create(:sub_main_category, main_category_id: @main_category.id)
  end

  describe "belongs_to" do
    context "sub_main_category" do
      it "should return sub_main_category of the current category" do
        category = FactoryGirl.create(:category, sub_main_category_id: @sub_main_category.id)
        # expect(category.sub_main_category).to eq(@sub_main_category)
      end
    end
  end

  describe "validates_numericality_of" do
    context "sub_main_category_id" do
      it "should be valid if sub_main_category_id is integer" do
        expect(FactoryGirl.create(:category, sub_main_category_id: @sub_main_category.id)).to be_valid
      end
      it "should be invalid if sub_main_category_id is not integer" do
        expect(FactoryGirl.build(:category, sub_main_category_id: "abcd")).not_to be_valid
      end
    end
    context "sequence_id" do
      it "should be valid if sequence_id is integer" do
        expect(FactoryGirl.create(:category, sub_main_category_id: @sub_main_category.id, sequence_id: 1)).to be_valid
      end
      it "should be invalid if sequence_id is not integer" do
        expect(FactoryGirl.build(:category, sub_main_category_id: @sub_main_category.id, sequence_id: "abc")).not_to be_valid
      end
    end
  end

  describe "validates_uniqueness_of" do
    context "name" do
      it "should not valid if same category the in same sub_main_category" do
        expect(FactoryGirl.create(:category, sub_main_category_id: @sub_main_category.id, name: "Abc")).to be_valid
        expect(FactoryGirl.build(:category, sub_main_category_id: @sub_main_category.id, name: "abc")).not_to be_valid
      end
      it "should allow to create same category name in different sub_main_category." do
        sub_main_category = FactoryGirl.create(:sub_main_category, main_category_id: @main_category.id, name: "Device", sequence_id: @main_category.sequence_id+1)
        expect(FactoryGirl.create(:category, sub_main_category_id: @sub_main_category.id)).to be_valid
        expect(FactoryGirl.create(:category, sub_main_category_id: sub_main_category.id)).to be_valid
      end
    end
    context "sequence_id" do
      it "should not valid if same sequence_id code the in same sub_main_category" do
        expect(FactoryGirl.create(:category, sub_main_category_id: @sub_main_category.id, name: "ABC")).to be_valid
        expect(FactoryGirl.build(:category, sub_main_category_id: @sub_main_category.id, name: "XYZ")).not_to be_valid
      end
    end
  end
end
