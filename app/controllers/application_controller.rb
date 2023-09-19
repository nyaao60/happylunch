class ApplicationController < ActionController::Base
  include SessionsHelper

  def logged_in_user
    if !logged_in?
      redirect_to login_path, alert: 'ログインしてから機能をお楽しみください。'
    end
  end

  def admin_user 
    if current_user.admin == false
      redirect_to root_path,alert: 'アクセスしたページは管理者のみ閲覧できます。'  
    end
  end

end
