class RelationshipsController < ApplicationController
  before_action :logged_in_user, only: [:create,:destroy]


  def create 
    current_user.follow(params[:followed_id])
    redirect_to request.referer
  end
  
  def destroy
    @user=Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    redirect_to request.referer
  end

  
  def followings
    user =  User.find(params[:user_id])
    @users = user.followings
  end

  def followers
    user=User.find(params[:user_id])
    @users=user.followers
  end
end
