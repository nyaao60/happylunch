class StaticPagesController < ApplicationController

  def home
    return @posts = Post.all if !logged_in? || current_user.following.count == 0
    user_ids = current_user.following.pluck(:id)
    user_ids.push(current_user.id)
    @posts=Post.where(user_id:user_ids).page(params[:page])
  end
  
end