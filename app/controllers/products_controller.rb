class ProductsController < ApplicationController
  
  before_action :require_user_logged_in, only: [:create,:new,:update,:destroy,:show,:edit]

  def create
    @product = current_user.products.build(product_params)
    if @product.save
      flash[:success]="新規作成できました。"
      redirect_to root_url
    else
      flash[:danger]="作成できませんでした。"
      render :new
    end
  
  
  end

  def new
    @product = current_user.products.build
  end

  #本人確認はupdateやindexではいらないが、なにかデータを書き換える時に必要（destroy,edit）。
  def edit
    @product = Product.find_by(id: params[:id])
     unless @product.user == current_user
        redirect_to root_path
     end
    #@product=current_user.products.find(params[:id])
    
  end

  def update
    @product=current_user.products.find(params[:id])
    if @product.update(product_params)
      flash[:success] = "正常に更新されました"
      redirect_to @product
    else
      flash.now[:danger] = "更新に失敗しました"
      render :edit
    end
    
  end

  def destroy
    @product=current_user.products..find_by(id: params[:id])
    if current_user==@product.user
      @product.destroy
      flash[:success] = "正常に削除できました"
      redirect_to root_url

    end
  end

  #アプリを開いてまず初めにぶつけるところ
  def index
    @products = Product.order(id: :desc).page(params[:page]).per(8)
  end

  def show
    @product = Product.find(params[:id])
    
    #このプロダクト詳細ページでコメントの作成、表示を行うから全コメントの取得、コメントモデルのインスタンスの生成
    @comments = @product.comments.order(id: :desc).page(params[:page]).per(6)
    @comment = current_user.comments.new
  end
  
  private

  #ストロングパラメータ
  def product_params
    params.require(:product).permit(:title,:language,:detail,:period)
  end
  
end
