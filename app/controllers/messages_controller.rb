class MessagesController < ApplicationController
  before_action :require_user_logged_in
  
  
  def create
    @message = current_user.messages.build(message_params)
    if @message.save
      #flash[:success] = 'メッセージを投稿しました。'
      redirect_to chat_room_path
    else
      @messages = Message.order(id: :desc).page(params[:page]).per(6)
      #flash.now[:danger] = 'メッセージの投稿に失敗しました。'
      render 'rooms/show'
    end
  end

  def destroy
    @message=current_user.messages.find(params[:id])
    if current_user.id == @message.user.id
      @message.destroy
      #flash[:success] = 'メッセージを削除しました。'
      redirect_back(fallback_location: chat_room_path)
    end
  end
  
  
  
  private

  def message_params
    params.require(:message).permit(:chat)
  end
  
end
