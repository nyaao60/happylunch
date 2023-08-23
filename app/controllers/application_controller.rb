class ApplicationController < ActionController::Base
  include SessionsHelper

  def logged_in_user
    unless logged_in?
      redirect_to login_path, alert: 'ログインしてから機能をお楽しみください。'
    end
  end

end
