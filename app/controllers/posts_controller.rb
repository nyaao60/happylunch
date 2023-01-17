class PostsController < ApplicationController

  def new
    @post=Post.new
  end

  def create
    @post=current_user.posts.build(post_params)
    if @post.save
      flash[:success]="投稿しました！"
      redirect_to root_url
    else
      flash.now[:alert]="入力に誤りがあります"
      render 'new'
    end
  end

  def show
    @post=Post.find(params[:id])
    @user=User.find_by(id:@post.user_id)
  end
  
  def edit
    @post=Post.find(params[:id])
  end  

  # def update
  #   @post=Post.find(params[:id])      
  #   if @post.update(post_params)
  #     flash[:success]="投稿を更新しました"
  #     redirect_to @post
  #   else
  #     render 'edit'
  #   end 
  # end  

  ApplicationRecord.transaction do
    @post = current_user.posts.find(params[:id]).destroy
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success]="投稿を更新しました"
      redirect_to @post
    else
      render 'edit'
    end 
  end  

  def destroy
    @post=Post.find(params[:id])
    if @post.destroy
    flash[:success]="投稿を削除しました" 
    redirect_to root_url
    end
  end
  
  private
    def post_params
      params.require(:post).permit(:store_name,:adress, {post_images:[]},:price,:five_star_rating,:lots_of_vegetables,:body)
    end
end