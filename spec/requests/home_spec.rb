require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "GET /home" do
    it "response 200" do
      get home_path
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end
end
