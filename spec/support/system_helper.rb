module SystemHelper
  
  def login
      user = create(:user)
      visit login_path
      fill_in'メールアドレス', with: user.email
      fill_in'パスワード', with: user.password
      click_button'ログイン'
  end
  
  def login_as(user)
    visit login_path
    fill_in'メールアドレス', with: user.email
    fill_in'パスワード', with: user.password
    click_button'ログイン'
  end
end