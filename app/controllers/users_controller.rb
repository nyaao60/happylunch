class UsersController < ApplicationController
before_action :correct_user,only:[:edit,:update]

  def new
    @user= User.new
  end

  def show
    @user = User.find(params[:id])
    @relationship=Relationship.find_by(follower_id:current_user.id,followed_id:@user.id)
    @posts=Post.where(user_id:params[:id])
  end  

  def index
    @users = User.all.page(params[:page])
  end

  def create
    @user=User.new(user_params)
    if @user.save
      log_in(@user)
      flash[:success]="ようこそ、ハピランチへ！"
      redirect_to @user 
    else
      flash.now[:alert]="入力に誤りがあります"
      render 'new'
    end
  end      

  def edit
    @user = User.find(params[:id])
  end 

  def update
    @user = User.find(params[:id])
    if @user.update(user_update_params)
      flash[:success]="プロフィールを更新しました！"
      redirect_to @user
    else
      render 'edit'
    end 
  end

  def following
    @title = "フォローしているユーザー"
    @user = User.find(params[:id])
    @users = @user.following.page(params[:page])
    render 'show_follow'
  end

  def followers
    @title = "フォローされているユーザー"
    @user  = User.find(params[:id])
    @users = @user.followers.page(params[:page])
    render 'show_follow'
  end

  def personal_posts
    @user=User.find(params[:id])
    @posts=Post.where(user_id:params[:id])
  end

  def likes
    @user=User.find(params[:id])
    likes=Like.where(user_id:params[:id]).pluck(:post_id)
    @posts=Post.where(id:likes)
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,:password_confirmation)
    end

    def user_update_params
      params.require(:user).permit(:name,
        :user_image,:self_introduction)
    end

    def correct_user 
      redirect_to root_url unless current_user=User.find(params[:id])
    end

end   