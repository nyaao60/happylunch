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
  
  private
    def post_params
      params.require(:post).permit(:store_name,:adress, {post_images:[]},:price,:five_star_rating,:lots_of_vegetables,:body)
    end
end

