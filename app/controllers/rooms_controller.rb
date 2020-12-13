class RoomsController < ApplicationController
  before_action :require_user_logged_in, only: [:show]
  def show
    @messages = Message.order(id: :desc).page(params[:page]).per(10)
    @message = current_user.messages.build
  end
end
