require 'test_helper'

# 基本的なテストプロセス

# invalidな場合
# 1. ログインパスへアクセス
# 2. new session form がちゃんと動作しているか
# 3. invalidなhash(session: {email: "", password: ""})のセッションを送る
# 4. new session formが再描画され、flashによるメッセージが表示
# 5. 他のページヘ移動(例: Home)
# 6. new pageにてflashによるメッセージが表示されないのを確認

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: "", password: "" }
    assert_template 'sessions/new'
    assert_not flash.empty?

    get root_path
    assert flash.empty?
  end
  test "login with valid information" do
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

end