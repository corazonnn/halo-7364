class Message < ApplicationRecord
  #speakアクションでcreateした後はjobファイルのperformを実行しなさい
  #after_create_commit { MessageBroadcastJob.perform_later self }
  
  belongs_to :user
  validates :chat, presence: true, length: { maximum: 100 }
  
  
end
