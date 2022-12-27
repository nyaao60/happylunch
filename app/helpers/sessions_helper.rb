module SessionsHelper  

def log_in(user)
  session[:user_id] =user.id
end

def current_user
  if session[:user_id]
    @current_user ||= User.find_by(id: session[:user_id])
  end
end

def logged_in?
  current_user.present?
end
 #メソッドの返り値は最後判定式の結果、つまりif session[:user_id]=nil=ログインしていない状態

def logout
  session[:user_id]=nil
  @current_user=nil 
end 

end