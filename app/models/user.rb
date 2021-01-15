class User < ApplicationRecord
  # mount_uploaderの第一引数には画像をアップロードするカラムを、第二引数にはアップローダーの設定ファイルのクラス名
  mount_uploader :image, ImageUploader
  before_save { email.downcase! }
  validates :username, presence: true, length: { maximum: 20 }
  validates :language, length: { maximum: 50 }
  validates :introduction, length: { maximum: 280 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password

  has_many :products, dependent: :destroy
  # 中間テーブルをたくさん持ってる
  has_many :goods, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :liked_products, through: :goods, source: :product
  def nice(any_product)
    # userがniceを押したらそのuserのgoodsテーブルにそのproduct追加する.0→→→1
    goods.find_or_create_by(product_id: any_product.id)
  end
  def unnice(any_product)
    # destroyは単体のレシーバーに対して削除するメソッドだから
    good = goods.find_by(product_id: any_product.id)
    good.destroy if good
  end
  def nice?(any_product)
    # 現在のユーザのgoodsの中に対象のproductがあればtrueを返す。それ以外はfalseにする。
    if goods.find_by(product_id: any_product.id)
      true
    else
      false
    end
  end
end