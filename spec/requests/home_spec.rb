# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Home", type: :request do
  describe "#top" do
    it "response 200" do
      get root_path
      expect(response).to be_success
      expect(response).to have_http_status(:ok)
    end
  end
end
