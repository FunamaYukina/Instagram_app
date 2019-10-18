require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "GET /home" do
    it "response 200" do
      get "/"
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end
  describe "GET /signup" do
    it "response 200" do
      get "/signup"
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end
  describe "GET /login" do
    it "response 200" do
      get "/login"
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end
end
