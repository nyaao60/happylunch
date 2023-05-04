module SessionsHelper  

  def log_in(user)
    session[:user_id] =user.id
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    elsif cookies.encrypted[:user_id]  
      user=User.find_by(id:cookies.encrypted[:user_id])
      if user && user.authenticated?(cookies[:remember_token])
      log_in user  
      @current_user =user
      end
    end  
  end

  def logged_in?
    current_user.present?
  end

  def remember(user)
  user.remember
  cookies.permanent.encrypted[:user_id]=user.id
  cookies.permanent[:remember_token]=user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def logout
    forget(current_user)
    session.delete(:user_id)
    @current_user=nil 
  end 

end