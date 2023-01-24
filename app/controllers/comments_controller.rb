class CommentsController < ApplicationController

  def create
    @post=Post.find(params[:post_id])
    @comment=current_user.@post.comments.build(comment_params)
    # post=Post.find(params[:post_id])
    # @comment=post.comments.build(comment_params)
    # @comment.user_id=current_user.id
    if @comment.save
        flash[:success]="投稿しました！"
        redirect_to post_path(@post)
      else
        flash[:alert]="コメントできませんでした"
        redirect_to post_path(@post)
      end
  end

  def destroy
    @comment=Comment.find(params[:id])
      if @comment.destroy
        flash[:success]="コメントを削除しました" 
        redirect_to post_path(@post)
      end  
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

end