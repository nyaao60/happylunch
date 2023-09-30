class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show,:index,:edit,:update,:accountedit,:accountupdate,:destroy]
  before_action :correct_user, only: [:edit,:update,:accountedit,:accountupdate,:destroy]
  before_action :ensure_normal_user, only: [:update,:accountedit,:accountupdate,:destroy]
  before_action :admin_user, only: [:index]

  def new
    @user= User.new
  end

  def show
    @user = User.find(params[:id])
    @relationship=Relationship.find_by(follower_id:current_user.id,followed_id:@user.id)
    @posts=Post.includes(:user,:likes,:comments,:tags).where(user_id:params[:id]).order(created_at: :desc).page(params[:page])
  end  

  def index
    @users = User.all.page(params[:page])
  end

  def create
    @user=User.new(user_params)
    if @user.save
      log_in(@user)
      flash[:success]="ようこそ、ハピランチへ！"
      redirect_to root_path 
    else
      flash.now[:alert]="ユーザーの作成に失敗しました。"
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

  def accountedit
    @user = User.find(params[:id])
  end

  def accountupdate
    @user = User.find(params[:id])
    if @user.update(user_accountupdate_params) 
      flash[:success]="アカウント情報を更新しました！"
      redirect_to root_path
    else
      render 'accountedit'
    end 
  end


  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "退会処理を完了しました！"
    redirect_to root_url
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
    @posts=Post.includes(:user,:likes,:comments,:tags).where(user_id:params[:id]).order(created_at: :desc).page(params[:page])
  end

  def likes
    @user=User.find(params[:id])
    likes=Like.where(user_id:params[:id]).pluck(:post_id)
    @posts=Post.includes(:user,:likes,:comments,:tags).where(id:likes).order(created_at: :desc).page(params[:page])
  end

  def guest
    user = User.find_or_create_by!(email: 'guest@example.com') do |user|
      user.name = "ゲストユーザー"
      user.password = SecureRandom.urlsafe_base64
      user.password_confirmation=user.password
    end
    log_in(user)
    flash[:success] = "ゲストユーザーとしてログインしました！"
    redirect_to root_url
  end

  def unsubscribe
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,:password_confirmation)
  end

  def user_update_params
    params.require(:user).permit(:name,
    :user_image,:self_introduction)
  end

  def user_accountupdate_params
    params.require(:user).permit(:email, :password,:password_confirmation)
  end

  def correct_user 
    if current_user != User.find(params[:id]) && current_user.admin == false
      redirect_to user_path(current_user),alert: '他のユーザーの編集や削除はできません。'  
    end
  end

  def ensure_normal_user
    if current_user.email == 'guest@example.com'
      redirect_to user_path, alert: '申し訳ございません、ゲストユーザーはユーザー編集や削除ができません。'
    end
  end

end   