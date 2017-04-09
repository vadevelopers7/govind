require 'rails_helper'

RSpec.describe SubMainCategory, type: :model do
  context 'validations'do
    ["main_category_id", "sequence_id", "name"].each do |field|
      it "should be invalid if #{field} is not present"do
        expect(FactoryGirl.build(:sub_main_category,"#{field}".to_sym =>nil)).not_to be_valid
      end
    end
  end

  before(:each) do
    @country = FactoryGirl.create(:country)
    @state = FactoryGirl.create(:state, country_id: @country.id)
    @city = FactoryGirl.create(:city, state_id: @state.id)
    @main_category = FactoryGirl.create(:main_category, city_id: @city.id)
  end

  describe "belongs_to" do
    context "main_category" do
      it "should return main_category of the current sub_main_category" do
        sub_main_category = FactoryGirl.create(:sub_main_category, main_category_id: @main_category.id)
        expect(sub_main_category.main_category).to eq(@main_category)
      end
    end
  end

  describe "validates_numericality_of" do
    context "main_category_id" do
      it "should be valid if main_category_id is integer" do
        expect(FactoryGirl.create(:sub_main_category, main_category_id: @main_category.id)).to be_valid
      end
      it "should be invalid if main_category_id is not integer" do
        expect(FactoryGirl.build(:sub_main_category, main_category_id: "abcd")).not_to be_valid
      end
    end
    context "sequence_id" do
      it "should be valid if sequence_id is integer" do
        expect(FactoryGirl.create(:sub_main_category, main_category_id: @main_category.id, sequence_id: 1)).to be_valid
      end
      it "should be invalid if sequence_id is not integer" do
        expect(FactoryGirl.build(:sub_main_category, main_category_id: @main_category.id, sequence_id: "abc")).not_to be_valid
      end
    end
  end

  describe "validates_uniqueness_of" do
    context "name" do
      it "should not valid if same sub_main_category the in same main_category" do
        expect(FactoryGirl.create(:sub_main_category, main_category_id: @main_category.id, name: "Abc")).to be_valid
        expect(FactoryGirl.build(:sub_main_category, main_category_id: @main_category.id, name: "abc")).not_to be_valid
      end
      it "should allow to create same sub_main_category name in different main_category." do
        main_category = FactoryGirl.create(:main_category, city_id: @city.id, name: "A", sequence_id: @main_category.sequence_id+1)
        expect(FactoryGirl.create(:sub_main_category, main_category_id: @main_category.id)).to be_valid
        expect(FactoryGirl.create(:sub_main_category, main_category_id: main_category.id)).to be_valid
      end
    end
    context "sequence_id" do
      it "should not valid if same sequence_id code the in same main_category" do
        expect(FactoryGirl.create(:sub_main_category, main_category_id: @main_category.id, name: "ABC")).to be_valid
        expect(FactoryGirl.build(:sub_main_category, main_category_id: @main_category.id, name: "XYZ")).not_to be_valid
      end
    end
  end
end
