require 'rails_helper'

RSpec.describe User, type: :model do

  it "emailが重複した場合、ユーザー登録に失敗すること" do
    User.create(
        email: "rrr@test.com",
        user_name: "rrr",
        full_name: "rrrrr",
        password: "rrrrrr")
    user = User.new(
        email: "rrr@test.com",
        user_name: "sss",
        full_name: "sssss",
        password: "ssssss")
    user.valid?
    expect(user.errors[:email]).to include 'はすでに存在します'
  end
end
