# frozen_string_literal: true

require "rails_helper"

RSpec.describe Image, type: :model do
  describe "validation" do
    context "新規投稿に失敗する場合" do
      it "画像を追加していない場合、投稿に失敗すること" do
        image = build(:image, :with_picture, image_file: nil)
        image.valid?
        expect(image.errors.full_messages).to include "画像を入力してください"
      end

      it "画像のサイズが5MBを超える場合、投稿に失敗すること" do
        image = build(:image, :with_large_file)
        image.valid?
        expect(image.errors.full_messages).to include "画像は4MB以下のものをアップロードしてください"
      end

      it "画像以外が投稿された場合、投稿に失敗すること" do
        image = build(:image, :with_incorrect_file_type)
        image.valid?
        expect(image.errors.full_messages).to include "画像を入力してください"
      end
    end

    context "新規投稿に成功する場合" do
      it "jpg画像を追加した場合、投稿に成功すること" do
        image = build(:image, :with_picture)
        expect(image).to be_valid
      end

      it "PNG画像を追加した場合、投稿に成功すること" do
        image = build(:image, :with_picture, image_file: Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/fixtures/test_png.png")))
        expect(image).to be_valid
      end

      it "jpeg画像を追加した場合、投稿に成功すること" do
        image = build(:image, :with_picture, image_file: Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/fixtures/test_jpeg.jpeg")))
        expect(image).to be_valid
      end

      it "gif画像を追加した場合、投稿に成功すること" do
        image = build(:image, :with_picture, image_file: Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/fixtures/test_gif.gif")))
        expect(image).to be_valid
      end
    end
  end
end
