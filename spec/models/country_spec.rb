require 'rails_helper'

RSpec.describe Country, type: :model do
  context 'validations'do
    ["name", "code" ].each do |field|
      it "should be invalid if #{field} is not present"do
        expect(FactoryGirl.build(:country,"#{field}".to_sym =>nil)).not_to be_valid
      end
    end
  end

  describe "has_many" do
  	context "states" do
  		it "should return states of current country" do
  			country = FactoryGirl.create(:country)
  			state = FactoryGirl.create(:state, country_id: country.id)
  			state1 = FactoryGirl.create(:state, country_id: country.id, name: "Delhi", code: "DL")
  			expect(country.states).to eq([state1,state])
  		end
  	end
  end

  describe "validates_uniqueness_of" do
    context "name" do
      it "should not allow to create same country" do
        expect(FactoryGirl.create(:country, name: "India")).to be_valid
        expect(FactoryGirl.build(:country, name: "india")).not_to be_valid
      end
    end
    context "code" do
      it "should not allow to create same country code as other country code" do
        expect(FactoryGirl.create(:country, name: "India", code: "IN")).to be_valid
        expect(FactoryGirl.build(:country, name: "USA", code: "IN")).not_to be_valid
      end
    end
  end
end
