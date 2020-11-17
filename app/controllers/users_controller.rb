class UsersController < ApplicationController
  #userを一覧表示する
  def index
    @users = User.order(id: :desc).page(params[:page]).per(12)
  end

  def show
    @user=User.find(params[:id])
  end

  def new
    @user=User.new
  end

  def create
  
  #明日はここから！登録ができない！！！！
    @user=User.new(user_params)
    
    if @user.save
      flash[:success]="アカウント登録に成功しました。"
      redirect_to @user
    else
      flash.now[:danger] = 'アカウント登録に失敗しました。'
      render :new
    end
  end

  def edit
  end

  def update
  end
  
  private
  #画像投稿用のメソッド
  def set_user
    @user = User.find(params[:id])
  end

   
  def user_params
    params.require(:user).permit(:image,:username,:email,:password,:password_confirmation)
  end
end
