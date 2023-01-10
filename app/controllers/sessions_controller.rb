class SessionsController < ApplicationController

  def new
  end

  def create
    user=User.find_by(email:params[:session][:email])
    if user&&user.authenticate(params[:session][:password])
    log_in(user)
    if params[:session][:remember] =="1"
    remember(user) 
    else
      forget(user) 
    end  
      redirect_to (user_url(user.id))
    else
      flash.now[:danger]='メールアドレスとパスワードの組み合わせが誤っています'
      render 'new'
    end
  end

  def destroy
    logout if logged_in?
    redirect_to root_url
  end  

end