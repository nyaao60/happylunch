class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create,:destroy]

  def create
    @post=Post.find(params[:post_id])
    @comment = Comment.new(user_id: current_user.id, post_id:@post.id, content:comment_params["content"])
    if @comment.save
        flash[:success]="コメントを投稿しました！"
        redirect_to post_path(@post)
      else
        flash[:alert]="コメントできませんでした"
        redirect_to post_path(@post)
      end
  end

  def destroy
    @post=Post.find(params[:post_id])
    @comment=Comment.find(params[:id])  
    if @comment.destroy
        flash[:success]="コメントを削除しました！" 
        redirect_to post_path(@post)
    end  
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

end