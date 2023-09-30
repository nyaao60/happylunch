class StaticPagesController < ApplicationController

  def home
    @tag_list = Tag.find(PostTagRelation.group(:tag_id).order('count(tag_id) desc').limit(8).pluck(:tag_id))
    
    if logged_in? && current_user.following.count > 0
      user_ids = current_user.following.ids << current_user.id
      @posts = Post.includes(:user, :likes, :comments, :tags).where(user_id: user_ids).order(created_at: :desc).page(params[:page])
    else
      @posts = Post.includes(:user, :likes, :comments, :tags).order(created_at: :desc)
    end
  end  

end