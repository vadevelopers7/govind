require 'rails_helper'

RSpec.describe City, type: :model do
  context 'validations'do
    ["state_id", "name", "code" ].each do |field|
      it "should be invalid if #{field} is not present"do
        expect(FactoryGirl.build(:city,"#{field}".to_sym =>nil)).not_to be_valid
      end
    end
  end

  before(:each) do
    @country = FactoryGirl.create(:country)
    @state = FactoryGirl.create(:state, country_id: @country.id)
  end

  describe "belongs_to" do
    context "state" do
      it "should return state of the current city" do
        city = FactoryGirl.create(:city, state_id: @state.id)
        expect(city.state).to eq(@state)
      end
    end
  end

  describe "validates_uniqueness_of" do
    context "name" do
      it "should not valid if same city the in same state" do
        expect(FactoryGirl.create(:city, state_id: @state.id, name: "Udaipur")).to be_valid
        expect(FactoryGirl.build(:city, state_id: @state.id, name: "udaipur")).not_to be_valid
      end
      it "should allow to create same city name in different state." do
        state = FactoryGirl.create(:state, country_id: @country.id)
        expect(FactoryGirl.create(:city, state_id: @state.id)).to be_valid
        expect(FactoryGirl.create(:city, state_id: state.id)).to be_valid
      end
    end
    context "code" do
      it "should not valid if same city code the in same state" do
        expect(FactoryGirl.create(:city, state_id: @state.id, name: "Udaipur")).to be_valid
        expect(FactoryGirl.build(:city, state_id: @state.id, name: "Jaipur")).not_to be_valid
      end
    end
  end
end
