require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "#top" do
    it "トップページでレスポンス200が返ってくること 200" do
      get root_path
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end
end
