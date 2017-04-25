require "rails_helper"

RSpec.describe EmailNotification, type: :mailer do
  describe 'signup' do
    let(:user) { FactoryGirl.build(:user) }
    let(:mail) { described_class.signup(user).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq('Welcome To LoveyDovy')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(["no_reply@loveydovy.com"])
    end

    it 'renders the body' do
      expect(mail.body).to eq("Dear #{user.first_name}, welcome to <a href='http://www.loveydovy.herokuapp.com/'>www.loveydovy.com</a>. To experience a great gift shopping.",)
    end

  end
end
