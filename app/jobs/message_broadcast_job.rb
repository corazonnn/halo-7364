class MessageBroadcastJob < ApplicationJob
  # jobを実行するキュー（または待ち行列はコンピュータの基本的なデータ構造の一つ）の指定するメソッド
  queue_as :default

  # messages/_message.html.erbにmessageをmessageを渡して、代入したものを再度messageに代入する。
  # ブロードキャストする処理の記述
  def perform(message)
    ActionCable.server.broadcast 'room_channel', message: message.chat
  end
end
