require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations'do
    ["email", "password", "role"].each do |field|
      it "should be invalid if #{field} is not present"do
        expect(FactoryGirl.build(:user,"#{field}".to_sym =>nil)).not_to be_valid
      end
    end
  end

  describe "validates_inclusion_of" do
    it { is_expected.to validate_inclusion_of(:role).in_array(['shopper', 'retailer', 'admin']) }
  end

  describe "#is_admin?" do
    it "should return true if a user role is admin" do
      expect(FactoryGirl.create(:user, role: "admin").is_admin?).to be true
    end
    it "should return false if a user role is not admin" do
      expect(FactoryGirl.create(:user).is_admin?).to be false
    end
  end

  describe "#is_shopper?" do
    it "should return true if a user role is shopper" do
      expect(FactoryGirl.create(:user, role: "shopper").is_shopper?).to be true
    end
    it "should return false if a user role is not shopper" do
      expect(FactoryGirl.create(:user, role: "admin").is_shopper?).to be false
    end
  end

  describe "#is_retailer?" do
    it "should return true if a user role is retailer" do
      expect(FactoryGirl.create(:user, role: "retailer").is_retailer?).to be true
    end
    it "should return false if a user role is not retailer" do
      expect(FactoryGirl.create(:user).is_retailer?).to be false
    end
  end

  describe "after_create" do
    context "send_registration_mail" do
      subject { FactoryGirl.build(:user) }
      it 'sends an email' do
        expect { subject.send(:send_registration_mail) }
          .to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end
  end

end
