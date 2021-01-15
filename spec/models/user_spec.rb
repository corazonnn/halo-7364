#完了
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'userを予め用意しておく！！' do
    let(:user) { FactoryBot.build(:user) }
  
    it "factory_botしっかり動いてる？" do
      expect(user).to be_valid
    end
    
    it "名前、メール、使用言語、自己紹介があれば有効！" do
      expect(user).to be_valid
    end
    
    it "名前がない場合、無効" do
      user = FactoryBot.build(:user, username: nil)
      user.valid?
      expect(user.errors[:username]).to include("can't be blank")
      #こんな書き方もできる！！！！
      #@user.username = nil
      #@user.valid?
      #expect(@user.errors[:username]).to include("can't be blank")
    end
    
    it "メールアドレスがない場合、無効" do
      user = FactoryBot.build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end
    
    it "パスワードが暗号化されているか" do 
      expect(user.password_digest).to_not eq "password"
    end 
    
    it "password(確認用)とpasswordが異なる場合保存できない" do 
      expect(FactoryBot.build(:user,password: "password",password_confirmation: "passward")).to_not be_valid 
    end 
  end
end



#これじゃダメだよね？(not_to)############expect(user).not_to be_valid（userって存在してないよね？）
#これを使うと「はい。だめです。」の時にfailarsになる。##########「はい。存在していないです。」でエラーが出る。


#WARN Selenium [DEPRECATION] Selenium::WebDriver::Chrome#driver_path= is deprecated. Use Selenium::WebDriver::Chrome::Service#driver_path= instead.
#このエラーなんだ？
#Chromedriverは非推奨だから、代わりにWebdriverを使ってね
#gemfileをいじって直してやったぞ！！！