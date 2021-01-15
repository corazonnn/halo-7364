class ProductsController < ApplicationController
  before_action :require_user_logged_in, only: %i[create new update destroy show edit]

  def create
    @product = current_user.products.build(product_params)
    if @product.save
      flash[:success] = '新規作成できました。'
      redirect_to root_url
    else
      flash[:danger] = '作成できませんでした。'
      render :new
    end
  end

  def new
    @product = current_user.products.build
  end

  # 本人確認はupdateやindexではいらないが、なにかデータを書き換える時に必要（destroy,edit）。
  def edit
    @product = Product.find_by(id: params[:id])
    redirect_to root_path unless @product.user == current_user
    # @product=current_user.products.find(params[:id])
  end

  def update
    #@product = current_user.products.find(params[:id])元々これだったけどrspecやってて下のに変えた
    @product = Product.find(params[:id])
    if @product.user == current_user
      if @product.update(product_params)
        flash[:success] = '正常に更新されました'
        redirect_to @product
      else
        flash.now[:danger] = '更新に失敗しました'
        render :edit
      end
    else
      redirect_to root_path
    end
  end

  def destroy
    #@product = current_user.products.find_by(id: params[:id])
    #最初は上だったけど、これだとrequest specのテストの時に[他のユーザーがログインして他の人の投稿を削除するテスト]が通らないから以下のようにした
    @product = Product.find_by(id: params[:id])
    if current_user == @product.user
      if @product.destroy
        flash[:success] = '正常に削除できました'
        redirect_to root_path
      else
        flash.now[:danger] = '削除に失敗しました'
        render :show
      end
    else
      redirect_to root_path
    end
  end

  # アプリを開いてまず初めにぶつけるところ
  def index
    @products = Product.order(id: :desc).page(params[:page]).per(6)
    # ランキング
    @rankranks = Product.includes(:liked_users).sort { |a, b| b.liked_users.size <=> a.liked_users.size }
    # このままだといいね 順で全てを表示することになってしまうからいいねの多い５つだけ表示する
    @rankings = @rankranks.first(5)

    # 検索機能
    @product_language = params[:option]
    case @product_language

    when '1'
      @searchs = Product.where(language: 'HTML&CSS').order(id: :desc).page(params[:page]).per(4)
    when '2'
      @searchs = Product.where(language: 'JavaScript').order(id: :desc).page(params[:page]).per(4)
    when '3'
      @searchs = Product.where(language: 'PHP').order(id: :desc).page(params[:page]).per(4)
    when '4'
      @searchs = Product.where(language: 'Ruby').order(id: :desc).page(params[:page]).per(4)
    when '5'
      @searchs = Product.where(language: 'Python').order(id: :desc).page(params[:page]).per(4)
    when '6'
      @searchs = Product.where(language: 'Java').order(id: :desc).page(params[:page]).per(4)
    when '7'
      @searchs = Product.where(language: 'C++').order(id: :desc).page(params[:page]).per(4)
    when '8'
      @searchs = Product.where(language: 'C#').order(id: :desc).page(params[:page]).per(4)
    when '9'
      @searchs = Product.where(language: 'Swift').order(id: :desc).page(params[:page]).per(4)
    when '10'
      @searchs = Product.where(language: 'R').order(id: :desc).page(params[:page]).per(4)
    end
  end

  def show
    @product = Product.find(params[:id])

    # このプロダクト詳細ページでコメントの作成、表示を行うから全コメントの取得、コメントモデルのインスタンスの生成
    @comments = @product.comments.order(id: :desc).page(params[:page]).per(6)
    @comment = current_user.comments.new
  end

  private

  # ストロングパラメータ
  def product_params
    params.require(:product).permit(:title, :language, :detail, :period, :option)
  end
end
