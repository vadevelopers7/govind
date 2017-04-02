require 'rails_helper'

RSpec.describe State, type: :model do
  context 'validations'do
    ["country_id", "name", "code" ].each do |field|
      it "should be invalid if #{field} is not present"do
        expect(FactoryGirl.build(:state,"#{field}".to_sym =>nil)).not_to be_valid
      end
    end
  end

  describe "belongs_to" do
  	context "country" do
  		it "should return country of the current state" do
  			country = FactoryGirl.create(:country)
  			state = FactoryGirl.create(:state, country_id: country.id)
  			expect(state.country).to eq(country)
  		end
  	end
  end

  describe "validates_uniqueness_of" do
    context "name" do
      it "should not valid if same state the in same country" do
        @country = FactoryGirl.create(:country)
        expect(FactoryGirl.create(:state, country_id: @country.id, name: "Rajasthan")).to be_valid
        expect(FactoryGirl.build(:state, country_id: @country.id, name: "rajasthan")).not_to be_valid
      end
      it "should allow to create same state name in different country." do
        country = FactoryGirl.create(:country)
        expect(FactoryGirl.create(:state, country_id: country.id)).to be_valid
      end
    end

    context "code" do
      it "should not allow to create same state code the in same country" do
        country = FactoryGirl.create(:country)
        expect(FactoryGirl.create(:state, country_id: country.id, name: "Rajasthan")).to be_valid
        expect(FactoryGirl.build(:state, country_id: country.id, name: "Gujrat")).not_to be_valid
      end
    end

  end
end
