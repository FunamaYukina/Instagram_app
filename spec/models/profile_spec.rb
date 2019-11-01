# frozen_string_literal: true

require "rails_helper"

RSpec.describe Profile, type: :model do
  describe "validation" do
    context "プロフィールの編集に成功する場合" do
      it "PNG画像を追加した場合、投稿に成功すること" do
        profile = FactoryBot.build(:profile)
        expect(profile).to be_valid
      end

      it "画像をアップロードしていない場合でも、編集に成功すること" do
        profile = FactoryBot.build(:profile, image_file: nil)
        expect(profile).to be_valid
      end

      it "自己紹介文がない場合でも、編集に成功すること" do
        profile = FactoryBot.build(:profile, introduction: nil)
        expect(profile).to be_valid
      end
    end

    context "プロフィールの編集に失敗する場合" do
      it "画像のサイズが4MBを超える場合、編集に失敗すること" do
        profile = FactoryBot.build(:profile, image_file: nil)
        profile.image_file = Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/fixtures/13MB.jpg"))
        profile.valid?
        expect(profile.errors.full_messages).to include "画像は4MB以下のものをアップロードしてください"
      end

      it "自己紹介文が150文字を超える場合、編集に失敗すること" do
        profile = FactoryBot.build(:profile, introduction: "a" * 151)
        profile.valid?
        expect(profile.errors.full_messages).to include "自己紹介文は150文字以内で入力してください"
      end
    end
  end
end
