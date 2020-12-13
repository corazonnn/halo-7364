class ApplicationController < ActionController::Base
  # logged_in?とcurrent_userはview用にlhelperで定義されたものだからcontrollerでは使えない。だからincludeする必要がある
  include SessionsHelper

  private

  def require_user_logged_in
    redirect_to login_url unless logged_in?
  end

  # ユーザの「頑張ったね！」した数を数える
  def counts(user)
    @count_goods = user.goods.count
  end

  def counted(product)
    @counted_goods = product.goods.count
  end
end
