class SessionsController < ApplicationController

  def new
  end

  def create
    user=User.find_by(email:params[:session][:email])
    if user&&user.authenticate(params[:session][:password]) 
      log_in(user)  
      redirect_to (user_url(user.id))
    else
      flash.now[:danger]='メールアドレスとパスワードの組み合わせが誤っています'
      render 'new'
    end
  end


  def destroy
  logout
  redirect_to "/signup"
  #仮置き,後でTOP画面に変更する。
  end  

end