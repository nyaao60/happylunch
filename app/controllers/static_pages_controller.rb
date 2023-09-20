class StaticPagesController < ApplicationController

  def home
    return @posts = Post.includes(:user,:likes,:comments).order(created_at: :desc) if !logged_in? || current_user.following.count == 0
    user_ids = current_user.following.pluck(:id)
    user_ids.push(current_user.id)
    @posts=Post.includes(:user,:likes,:comments).where(user_id:user_ids).order(created_at: :desc).page(params[:page])
  end
  
end