class User < ApplicationRecord
  mount_uploader :image, ImageUploader
  before_save { self.email.downcase! }
  validates :username, presence: true, length: { maximum: 50 }
  
  #これを書いちゃうとユーザ登録時に必要とされちゃうから一旦外してみる→やっぱりそうだ！
  #validates :language, presence: true, length: { maximum: 50 }
  #validates :introduction, presence: true, length: { maximum: 280 }
  
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
                    
  #mount_uploaderの第一引数には画像をアップロードするカラムを、第二引数にはアップローダーの設定ファイルのクラス名 
  mount_uploader :image, ImageUploader
  
  has_secure_password
    
end
