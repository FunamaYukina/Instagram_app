# frozen_string_literal: true

require "rails_helper"

RSpec.describe Image, type: :model do
  context "新規投稿に失敗する場合" do
    it "画像を追加していない場合,投稿に失敗すること" do
      image = FactoryBot.build(:image, image_file: "")
      image.valid?
      expect(image.errors.full_messages).to include "画像を入力してください"
    end
  end
end
