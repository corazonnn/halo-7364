class ApplicationController < ActionController::Base
  
  #logged_in?はview用にlhelperで定義されたものだからcontrollerでは使えない。だからincludeする必要がある
  include SessionsHelper
  private
  
  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
end
