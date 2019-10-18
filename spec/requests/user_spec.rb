require 'rails_helper'

RSpec.describe User, type: :request do

  describe "POST users#create"
  it "signup success" do
    get "/signup"
    expect(response).to be_success
    expect(response).to have_http_status(200)
  end

  it "save new user" do
    expect do
      post :create, params: {
          email: "rrr@test.com",
          name: "rrr",
          full_name: "rrrrr",
          password: "rrr"
      }
    end
  end
  describe "POST users#create"
  it "login success" do
    get "/login"
    expect(response).to be_success
    expect(response).to have_http_status(200)
  end

  it "save new user" do
    expect do
      post :login, params: {
          email: "aaa@test.com",
          password: "rrr"
      }
    end
  end
end
