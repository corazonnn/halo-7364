module SessionsHelper
  def current_user
    # @current_user に既にあるか？？？ないなら→Userから探してきてcurrent_userに代入する
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    # current_userが存在すればture、しないならfalse
    !!current_user
  end
end
