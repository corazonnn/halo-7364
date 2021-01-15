require 'rails_helper'

RSpec.describe "ログインできているか", type: :request do
  describe "GET /sessions/new" do
    it 'ログイン画面の表示に成功すること' do
      get login_path
      expect(response).to have_http_status(200)
    end
  end
  
  #############################################################################

  describe "POST /sessions/create" do
    before do
      user_a = FactoryBot.create(:user,email: 'ruffy@ruffy.com')
    end
    it 'ログインんが成功するかどうか' do
      post login_path, params: { session: {email: 'ruffy@ruffy.com',password: 'ruffy' }}
      expect(response).to redirect_to root_path
    end
    it 'ログインに失敗する' do
      post login_path, params: { session: {email: 'fail@ruffy.com',password: 'ruffy' }}
      expect(response.body).to include 'ログインに失敗しました。'
    end
  end
  
  #############################################################################
  describe "DELETE /sessions/destroy" do
    
    let(:user) { FactoryBot.create(:user) }
    
    it 'ログアウトが成功するかどうか' do
      #spec/support内でヘルパーとして呼び出している
      sign_in_as(user)     # spec/support/utilities.rbに定義
      #post login_path, params: { session: { email: user.email, password: user.password } }
      # ログアウトする
      delete logout_path
      expect(session[:user_id]).to eq nil
      
      
    end
    
  end
end