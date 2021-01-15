class SessionsController < ApplicationController
  def new
    # データベースがないから特にやることはない
  end

  def create
    # フォームから送られてきた情報でログインする
    # まずは送られたデータをemailとpasswordに分ける
    # わけたemailが今あるUserテーブルの中にあるのかifをつかう
    # もしあればそれが送られたパスワードと一致するか確かめる。OKなら中に入れる
    # そんなユーザはいないorパスワードが違う。→もう一度ログインフォームに送りつける
    email = params[:session][:email].downcase
    password = params[:session][:password]
    if login(email, password)
      flash[:success] = 'ログインに成功しました。'
      redirect_to root_url
    else
      flash.now[:danger] = 'ログインに失敗しました。'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url
  end
end

private

def login(email, password)
  @user = User.find_by(email: email)
  if @user && @user.authenticate(password)
    session[:user_id] = @user.id
    true
  else
    false
  end
end
