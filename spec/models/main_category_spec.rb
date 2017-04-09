require 'rails_helper'

RSpec.describe MainCategory, type: :model do
  context 'validations'do
    ["city_id", "sequence_id", "name", "icon"].each do |field|
      it "should be invalid if #{field} is not present"do
        expect(FactoryGirl.build(:main_category,"#{field}".to_sym =>nil)).not_to be_valid
      end
    end
  end

  before(:each) do
    @country = FactoryGirl.create(:country)
    @state = FactoryGirl.create(:state, country_id: @country.id)
    @city = FactoryGirl.create(:city, state_id: @state.id)
  end

  describe "belongs_to" do
    context "city" do
      it "should return city of the current category" do
        main_category = FactoryGirl.create(:main_category, city_id: @city.id)
        expect(main_category.city).to eq(@city)
      end
    end
  end

  describe "validates_numericality_of" do
    context "city_id" do
      it "should be valid if city_id is integer" do
        expect(FactoryGirl.create(:main_category, city_id: @city.id)).to be_valid
      end
      it "should be invalid if city_id is not integer" do
        expect(FactoryGirl.build(:main_category, city_id: "abcd")).not_to be_valid
      end
    end
    context "sequence_id" do
      it "should be valid if sequence_id is integer" do
        expect(FactoryGirl.create(:main_category, city_id: @city.id, sequence_id: 1)).to be_valid
      end
      it "should be invalid if sequence_id is not integer" do
        expect(FactoryGirl.build(:main_category, city_id: @city.id, sequence_id: "abc")).not_to be_valid
      end
    end
  end

  describe "validates_uniqueness_of" do
    context "name" do
      it "should not valid if same category the in same city" do
        expect(FactoryGirl.create(:main_category, city_id: @city.id, name: "Abc")).to be_valid
        expect(FactoryGirl.build(:main_category, city_id: @city.id, name: "abc")).not_to be_valid
      end
      it "should allow to create same category name in different city." do
        city = FactoryGirl.create(:city, state_id: @state.id, code: "JP", name: "Jaipur")
        expect(FactoryGirl.create(:main_category, city_id: @city.id)).to be_valid
        expect(FactoryGirl.create(:main_category, city_id: city.id)).to be_valid
      end
    end
    context "sequence_id" do
      it "should not valid if same sequence_id code the in same city" do
        expect(FactoryGirl.create(:main_category, city_id: @city.id, name: "ABC")).to be_valid
        expect(FactoryGirl.build(:main_category, city_id: @city.id, name: "XYZ")).not_to be_valid
      end
    end
  end
end
