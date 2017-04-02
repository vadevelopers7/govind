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
end
