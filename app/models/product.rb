class Product < ApplicationRecord
  belongs_to :user
  
  validates :title, presence: true, length: { maximum: 30 }
  validates :language, presence: true, length: { maximum: 255 }
  validates :detail, length: { maximum: 255 }
  validates :period, length: { maximum: 255 }
 
  #あとはimageについて書くだけ。それ以外はできた
  
  #中間テーブルをたくさん持っている
  #dependent: :destroyをつけると「いいね」をもらったものも消せる
  has_many :goods, dependent: :destroy
  
  
  
  
  has_many :comments, dependent: :destroy
  
end
