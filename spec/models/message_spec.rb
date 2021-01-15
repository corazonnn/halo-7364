require 'rails_helper'
RSpec.describe Message, type: :model do
  describe 'user,chatを予め用意しておく！！' do
    let(:user) { FactoryBot.build(:user) }
    let(:message) { FactoryBot.build(:message) }
    
    it "factory_bot(message)しっかり動いてる？" do
      expect(message).to be_valid
    end
    
    it "chatとuserが紐づいていないと無効" do
      #これで紐づいていないと動かないことを確かめたい×、万が一userと関連付がされていなかった場合には、
      #「expectでuserは存在しないといけませんよー」を予め回り込んで予測しておいて、その通り動いたらエラーは出ないようにしておく。
      #つまりは 関連付けしなかった場合はmust exitと出ればエラーは出ないけど、それ以外の挙動を起こしたらエラーが出るようにする。
      message = FactoryBot.build(:message, user: nil)
      message.valid?
      expect(message.errors[:user]).to include("must exist")
    end
    
    it "chatがあれば有効" do
      expect(message).to be_valid
    end
    
    it "chatがないと無効" do
      message = FactoryBot.build(:message, chat: nil)
      message.valid?
      expect(message.errors[:chat]).to include("can't be blank")
    end
    
    it "chatの文字数が87文字以上で無効" do
      message = FactoryBot.build(:message, chat: "あ" * 87)
      message.valid?
      expect(message.errors[:chat]).to include("is too long (maximum is 86 characters)")
      #もう一つの書き方
      #message = FactoryBot.build(:message, chat: "あ" * 86)
      #expect(message).to be_invalid
    end
  end
end
