require 'rails_helper'

RSpec.describe Country, type: :model do
  context 'validations'do
    ["name", "code" ].each do |field|
      it "should be invalid if #{field} is not present"do
        FactoryGirl.build(:country,"#{field}".to_sym =>nil).should_not be_valid
      end
    end
  end
end
