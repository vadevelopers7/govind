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
  			state1 = FactoryGirl.create(:state, country_id: country.id, name: "Delhi")
  			expect(country.states).to eq([state,state1])
  		end
  	end
  end
end
