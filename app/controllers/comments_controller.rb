class CommentsController < ApplicationController
  def create
    @product = Product.find(params[:product_id])
    @comment = @product.comments.new(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash[:success] = 'コメントを投稿しました'
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = '投稿に失敗しました'
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    # @comment = Comment.find(params[:id])
    @comment = current_user.comments.find(params[:comment_id])
    @comment.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def comment_params
    # Q.なぜここでpost_idを必要としているのか？
    # A.コメントの内容とともにどのプロダクトへのコメントか判断するためかな？
    params.require(:comment).permit(:reply)
  end
end
