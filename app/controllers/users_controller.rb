class UsersController < ApplicationController
  
  before_action :require_user_logged_in, only: [:show,:edit]
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
  #明日はここから！登録ができない！！！！→できた！！！
    @user=User.new(user_params)
    #最初はデフォルトのアイコンを入れておく
    #できなかった涙涙涙@user.image="default_icon.png"
    if @user.save
      flash[:success]="アカウント登録に成功しました。"
      redirect_to @user
    else
      flash.now[:danger] = 'アカウント登録に失敗しました。'
      render :new
    end
  end

  def edit
    @user=User.find(params[:id])
     unless @user == current_user
      redirect_to root_path
     end
    
  end


  def update
    @user=User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'プロフィールは更新されました'
      redirect_to @user
    else
      flash.now[:danger] = 'プロフィールは更新できませんでした'
      render :edit
    end
  end
  
  
  #userモデルファイルのmemberの中
  #これはユーザの「頑張ったね！」した一覧を表示するためのものだが今現時点では必要ない
  def nices
  end
  
  
  private
  #画像投稿用のメソッド
  def set_user
    @user = User.find(params[:id])
  end

   
  def user_params
    params.require(:user).permit(:image,:username,:email,:password,:password_confirmation,:introduction,:language)
  end
end
