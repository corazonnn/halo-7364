class GoodsController < ApplicationController
  before_action :require_user_logged_in
  
  
  def create
    #現在のユーザが対象のプロダクトをgoodsテーブルの中に追加する
    @product=Product.find(params[:product_id])
    #niceメソッドはgoodのモデルファイルで定義している
    current_user.nice(@product)
    redirect_back(fallback_location: root_path)
  end
  

  def destroy
    @product=Product.find(params[:product_id])
    current_user.unnice(@product)
    redirect_back(fallback_location: root_path)                                                                                                                                                                                                                        
  end
end
