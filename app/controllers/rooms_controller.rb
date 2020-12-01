class RoomsController < ApplicationController
  def show
    @messages = Message.order(id: :desc).page(params[:page]).per(6)
    @message = current_user.messages.build 
  end
end
