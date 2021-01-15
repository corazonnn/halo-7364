require 'rails_helper'
#type::controllerからtype::requestに変わった！これにずっと悩まされてた。。
RSpec.describe Product, type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:product) { FactoryBot.create(:product,user: user) } #アクセスするためにはidが必要となるため
  #############################################################################
  describe 'GET #index' do
    before do
      get products_path
    end
    it "index正常なレスポンスかどうか？" do
      expect(response).to be_successful
    end
    it 'products_pathのリクエストが200 OKとなること' do
      expect(response.status).to eq 200
    end
  end
  #############################################################################
  describe 'GET #show' do
    context "ログインしているユーザー" do
      it 'リクエストは200 OKとなること' do
        sign_in_as(user)
        get product_path(product.id)
        expect(response.status).to eq 200
        expect(product.reload.title).to eq "四皇"
      end
    end
    context "ログインしていないユーザー" do
      it 'ログインページにリダイレクトされる' do
        get product_path(product.id)
        expect(response).to redirect_to login_path
        expect(response.status).to eq 302
      end
    end
  end
  #############################################################################
  describe 'GET #edit' do
   context "ログインしているユーザー" do
      it 'リクエストは200 OKとなること' do
        sign_in_as(user)
        get edit_product_path(product.id)
        expect(response.status).to eq 200
      end
    end
    context "ログインしていないユーザー" do
      it 'rootページにリダイレクトされる' do
        get edit_product_path(product.id)
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
  describe 'GET #new' do
    context 'ログインしているユーザー' do
      it 'リクエストは200 OKとなること' do
        sign_in_as(user)
        get new_product_path
        expect(response.status).to eq 200
      end
    end
    context 'ログインしていないユ���ザー' do
      it 'ログインページにリダイレクトされる' do
        get new_product_path
        expect(response).to redirect_to login_path
      end
    end
  end
  #############################################################################
  describe 'POST #create' do
    #新しいproductを作る
    let(:product_params) do 
      { product: {
        title: "四皇",
        language: "PHP",
        detail: "ウオウオの実",
        period: "8年",
        user: user
       }
      }
    end
    let(:product_fail_params) do 
      { product: {
        title: nil,
        language: "PHP",
        detail: "ウオウオの実",
        period: "8年",
        user: user
       }
      }
    end
    context 'ログインしているユーザー' do
      it 'productの数が一つ増えていること' do
        sign_in_as(user)
        #POSTで投稿の新規作成,数が一つ増えているかexpect
        expect {post products_path, params: product_params }.to change(Product, :count).by(1)
      end
      it '作成できたらroot_pathにリダイレクト' do
        sign_in_as(user)
        expect(post products_path, params: product_params).to redirect_to(root_path)
      end
      it '作成に失敗したら投稿数が増えない' do
        sign_in_as(user)
        expect{ post products_path, params: product_fail_params}.to change(Product, :count).by(0)
      end
      it '作成に失敗したらnewにrender' do
        sign_in_as(user)
        expect(post products_path, params: product_fail_params).to render_template :new
      end
    end
    context 'ログインしていないユーザー' do
      it '新規作成しようとしてもログインページに飛ばされる' do
        expect(post products_path, params: product_params).to redirect_to(login_path)
      end
    end
  end
  #############################################################################
  describe 'PATCH #update' do
    context 'ログインしているユーザー' do
      it '投稿内容の更新' do
        product_update_params = FactoryBot.attributes_for(:product, title: "編集しました")
        sign_in_as(user)
        patch product_path(product), params: { id: product.id, product: product_update_params }
        expect(product.reload.title).to eq "編集しました"
      end
      it '成功したらproductの詳細ページにリダイレクト' do
        product_update_params = FactoryBot.attributes_for(:product, title: "編集しました")
        sign_in_as(user)
        expect(patch product_path(product), params: { id: product.id, product: product_update_params }).to redirect_to(product_path(product.id))
      end
      it '失敗したらeditにレンダー' do
        product_update_params = FactoryBot.attributes_for(:product, title: nil)
        sign_in_as(user)
        expect(patch product_path(product), params: { id: product.id, product: product_update_params }).to render_template :edit

      end
    end
    context 'ログインしていないユーザー' do
      it 'ログインページに飛ばされる' do
        product_update_params = FactoryBot.attributes_for(:product, title: "編集しました")
        patch product_path(product), params: { id: product.id, product: product_update_params }
        expect(response).to redirect_to login_path
      end
    end
    context '別のユーザー' do
      it 'root_pathに飛ばされる' do
        sign_in_as(other_user)
        product_update_params = FactoryBot.attributes_for(:product, title: "編集しました")
        expect(patch product_path(product), params: { id: product.id, product: product_update_params }).to redirect_to(root_path)
      end
    end
  end
  #############################################################################
  describe 'DELETE #destroy' do
    
    context 'ログインしているユーザー' do
      it '投稿数が一つ減っている' do
        product_params = user.products.create(title: "削除用",language: "PHP",detail: "ウオウオの実",period: "8年",user: user)
        sign_in_as(user)
        expect{ product_params.destroy }.to change{ Product.count }.by(-1) 
      end
      it '投稿が削除できたらrootに飛ばす' do
        product_params = user.products.create(title: "削除用",language: "PHP",detail: "ウオウオの実",period: "8年",user: user)
        sign_in_as(user)
        expect( product_params.destroy ).to redirect_to(root_path)
      end
    end
    context 'ログインしていないユーザー' do
      it 'ログインページに飛ばされる' do
        product_params = user.products.create(title: "削除用",language: "PHP",detail: "ウオウオの実",period: "8年",user: user)
        delete product_path(product), params: { id: product.id, product: product_params }
        expect(response).to redirect_to login_path
      end
    end
    context '別のユーザー' do
      it 'root_pathに飛ばされる' do
        sign_in_as(other_user)
        product_params = user.products.create(title: "削除用",language: "PHP",detail: "ウオウオの実",period: "8年",user: user)
        delete product_path(product), params: { id: product.id, product: product_params }
        expect(response).to redirect_to root_path
      end
    end
  end
  
end