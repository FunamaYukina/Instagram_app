require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "#top" do
    it "レスポンス200が返ってくること" do
      get root_path
      expect(response).to be_success
      expect(response).to have_http_status(:ok)
    end
  end
end
