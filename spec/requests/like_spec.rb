require "rails_helper"
require "support/utilities"

RSpec.describe "likes", type: :request do
  describe "#like_and_#unlike" do
    context "未ログインの場合" do
      it "いいねができないこと" do
        get root_path
        expect(response.body).not_to include ".like_button"
      end
    end
    context "ログイン済みの場合" do
      before do
        signup
        log_in
        post_message_and_image
      end
      it "いいねしていない場合、いいねができること" do
        expect do
          get root_path
          post like_path(post_id: 1),xhr: true, params: {post_id: 1, user_id: 1}
        end.to change(Like, :count).by(1)
      end
      it "いいねしていた場合、いいねの解除ができること" do
        get root_path
        post like_path(post_id: 1),xhr: true, params: {post_id: 1, user_id: 1}
        get root_path
        expect do
          post unlike_path(post_id: 1),xhr: true, params: {post_id: 1, user_id: 1}
        end.to change(Like, :count).by(1)
      end
    end
  end
end