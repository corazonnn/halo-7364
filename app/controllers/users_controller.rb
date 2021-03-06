#ちょっと編集
class UsersController < ApplicationController
  before_action :require_user_logged_in, only: %i[show edit update]
  # userを一覧表示する
  def index
    @users = User.order(id: :desc).page(params[:page]).per(12)
  end

  def show
    @user = User.find(params[:id])
    @user_product = @user.products.order(id: :desc).page(params[:page]).per(6)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    # 最初はデフォルトのアイコンを入れておく
    # できなかった涙涙涙@user.image="default_icon.png"
    if @user.save
      flash[:success] = 'アカウント登録に成功しました。'
      redirect_to root_url
    else
      flash.now[:danger] = 'アカウント登録に失敗しました。'
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
    redirect_to root_path unless @user == current_user
  end

  def update
    @user = User.find(params[:id])
    if @user == current_user
      if @user.update(user_params)
        flash[:success] = 'プロフィールは更新されました'
        redirect_to @user
      else
        flash.now[:danger] = 'プロフィールは更新できませんでした'
        render :edit
      end
    else
      redirect_to root_path
    end
  end

  private

  # 画像投稿用のメソッド
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:image, :username, :email, :password, :password_confirmation, :introduction, :language)
  end
end
