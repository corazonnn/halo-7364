require 'rails_helper'

RSpec.describe User, type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  #############################################################################
  describe 'GET #new' do
    before do
      get signup_path 
    end
    it "レスポンスが200であること" do
      expect(response).to have_http_status(:ok)
    end
    it "正しいviewにrenderすること" do
      expect(response).to render_template :new
    end
    it "新しいproductオブジェクトがviewに渡されること" do
      expect(assigns(:user)).to be_a_new User
    end
  end
  #############################################################################
  describe 'GET #index' do
    before do
      get users_path 
    end
    it "レスポンスが200であること" do
      expect(response).to have_http_status(:ok)
    end
    it "正しいviewにrenderすること" do
      expect(response).to render_template :index
    end
  end
  #############################################################################
  describe 'POST create' do #アカウント登録成功用テストデータ
    let(:params) do 
      { user: {
        username: "zoro",
        email: "ruffy@ruffy.com",
        password: "ruffy"
       }
      }
    end
    let(:signup_user) do #アカウント登録失敗用テストユーザー
      { user: {
        username: nil,
        email: nil,
        password: nil
       }
      }
    end
    it 'アカウント登録に成功(=ユーザーが一人増えている)' do
      expect {post users_path, params: params }.to change(User, :count).by(1)
    end
    it "アカウント登録したらrootページにリダイレクトすること" do
      #本当はredirect_toでuserの詳細ページに飛ばしたかったけどできないから渋々root_pathにした。なおusers/controllerのcreateアクションのredirect_toをroot_pathに変更した
      expect(post users_path, params: params).to redirect_to(root_path)
    end
    
    it "アカウント登録に失敗(=バリデーションに引っかかるようにすればいい)" do
        expect{ post users_path, params: signup_user}.to change(User, :count).by(0)
    end
    it "アカウント失敗したらnewページにrenderされる" do
      expect(post users_path, params: signup_user).to render_template :new
    end
  end
  #############################################################################
  describe 'GET #show' do
    context "ログインしているユーザー" do
      it 'リクエストは200 OKとなること' do
        sign_in_as(user)
        get user_path(user.id)
        expect(response.status).to eq 200
      end
    end
    context "ログインしていないユーザー" do
      it 'ログインページにリダイレクトされる' do
        get user_path(user.id)
        expect(response).to redirect_to login_path
      end
    end
  end
  #############################################################################
  describe 'GET #edit' do
    context "ログインしているユーザー" do
      it 'リクエストは200 OKとなること' do
        sign_in_as(user)
        get edit_user_path(user.id)
        expect(response.status).to eq 200
      end
    end
    context "ログインしていないユーザー" do
      it 'rootページにリダイレクトされる' do
        get edit_user_path(user.id)
        expect(response).to redirect_to login_path
      end
    end
    context "ログインしているけど別のユーザー" do
      it 'rootページにリダイレクトされる' do
        sign_in_as(other_user)
        get edit_user_path(user)
        expect(response).to redirect_to root_path
      end
    end
  end
  #############################################################################
  describe 'PATCH #update' do
    context "ログインしているユーザー" do
      #attributes_forを使う理由。この場合はデータがハッシュで表されるからupdateやcreateに便利。いちいちtitle: タイトルとか指定しなくてもいい 
      
      it 'ユーザーを更新する' do 
        user_params = FactoryBot.attributes_for(:user, introduction: "自己紹介変えました")
        sign_in_as(user)
        patch user_path(user), params: { id: user.id, user: user_params }
        expect(user.reload.introduction).to eq "自己紹介変えました"
      end
      it '更新失敗したらeditにrender' do
        user_params = FactoryBot.attributes_for(:user, username: nil)
        sign_in_as(user)
        expect(patch user_path(user), params: { id: user.id, user: user_params }).to render_template :edit
      end
    end
    context "ログインしていないユーザー" do
      it 'ユーザーを更新しようとするけどログインページに飛ばされる' do
        user_params = FactoryBot.attributes_for(:user, introduction: "自己紹介変えました")
        patch user_path(user), params: { id: user.id, user: user_params }
        expect(response).to redirect_to login_path
      end
    end
    context "ログインしているけど別のユーザー" do
      it '更新できない&&rootページにリダイレクト' do
        user_params = FactoryBot.attributes_for(:user, introduction: "自己紹介変えました")
        sign_in_as other_user
        patch user_path(user), params: { id: user.id, user: user_params }
        expect(response).to redirect_to root_path
      end
    end
    
    
  end
end