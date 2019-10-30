# frozen_string_literal: true

require "rails_helper"
require "support/utilities"

RSpec.describe "Home", type: :request do
  describe "#top" do
    before do
      FactoryBot.create(:post)
    end

    it "レスポンス200が返ってくること" do
      get root_path
      expect(response).to be_success
      expect(response).to have_http_status(:ok)
    end
  end
end
