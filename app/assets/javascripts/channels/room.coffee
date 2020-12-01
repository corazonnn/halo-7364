App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  #チャンネル内でデータを受け取った時のリアクション。今はアラームが出るようにしている
  received: (data) ->
    #alert data['message']
    #ブロードキャストされたmessageを、viewにappendする。
    $('#messages').append data['message']

  #サーバーサイドのspeakアクションを呼び出し、messageにmessageを入れる
  #ここでの（message）はフォームによって代入されたテキストのこと。それをmessageというパラメータに入れて渡す。ちょっとややこしい
  speak: (message) ->
    @perform 'speak', message: message
    
#エンターキーを押した後の挙動
jQuery(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
  if event.keyCode is 13 # return = send
    App.room.speak event.target.value
    event.target.value = ''
    event.preventDefault()