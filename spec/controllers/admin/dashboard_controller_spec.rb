require 'rails_helper'

RSpec.describe Admin::DashboardController, type: :controller do

  describe "GET #index" do
    subject { get :index }
    it "renders the index template" do
      expect(subject).to render_template("admin_dashboard/logged_in")
    end
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end

end
