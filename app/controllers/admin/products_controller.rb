#管理者権限
class Admin::ProductsController < ApplicationController
  before_action :if_not_admin
  
  def index
    @products = Product.order(id: :desc).page(params[:page]).per(12)
  end

  def show
    @product = Product.find(params[:id])
  end
  def destroy
    @product = Product.find_by(id: params[:id])
    if @product.destroy
      flash[:success] = '正常に削除できました'
      redirect_to root_path
    else
      flash.now[:danger] = '削除に失敗しました'
      render :show
    end
  end
  def destroy
    @product = Product.find_by(id: params[:id])
      if @product.destroy
        flash[:success] = '正常に削除できました'
        redirect_to root_path
      else
        flash.now[:danger] = '削除に失敗しました'
        render :show
      end
  end
  
  private
  #管理者ではないとroot_pathにぶっ飛ばす
  def if_not_admin
    redirect_to root_path unless current_user.admin?
  end
end
