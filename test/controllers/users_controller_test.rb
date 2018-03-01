require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get signup" do
    get signup_url
    assert_response :success
  end

  def setup
    @user=users(:michael)
    @other_user=users(:archer)
  end

  test "should redirect edit attempt from non logged in users" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect non logged in attempt on update" do
    patch user_path(@user), params: { user: {name: "Greg", email: "email@email.com" }}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit attempt from wrong user" do
    log_in_as(@user)
    get edit_user_path(@other_user)
    assert flash.empty?
    assert_redirected_to root_url
  end
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end


  test " should redirect update attemp from wrong user" do
    log_in_as(@user)
    patch user_path(@other_user), params: { user: {name: "Greg", email: "email@email.com" }}
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "redirect non logged in user" do
    get users_path
    assert_redirected_to login_url
  end
end
