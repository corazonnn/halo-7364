class RoomChannel < ApplicationCable::Channel
  #ブロードキャストした時のストリームをroom_channelにする
  def subscribed
    stream_from "room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    #クライアント再度のspeakアクションから渡されたパラメーターをdataとして受け取り、room_channelにmessageをブロードキャストする。
    #ActionCable.server.broadcast 'room_channel', message: data['message']
    #受け取ったデータのmessageをMessageテーブルのchatカラムに入れて保存する。ブロードキャストに関しては非同期のためjobファイルで行う。
    
    #MessageとUserが紐づいているから多分できない。current_userを使わないと、、、
    Message.create! chat: data['message']
  end
end
