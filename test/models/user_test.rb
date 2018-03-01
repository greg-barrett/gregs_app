require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user= User.new(name: "Gregory Barrett", email:"gregory@msn.com", password:"foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid? #is true?
  end

  test "name should not be blank" do
    @user.name="      "
    assert_not @user.valid? # without validation the error message reads "expected true to be false"
  end

  test "email shoud not be blank" do
    @user.email= "      "
    assert_not @user.valid?
  end

  test "length of name should be 50 characters or less" do
    @user.name="a"*51
    assert_not @user.valid?
  end

  test "length of email should be 255 characters or less" do
    @user.email="a"*256
    assert_not @user.valid?
  end

  test "good email addresses should be valid" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                      first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid|
      @user.email=valid
      assert @user.valid?, "#{valid.inspect} should be valid"
    end
  end

  test "bad email addresses should be invalid" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid|
      @user.email=invalid
      assert_not @user.valid?, "#{invalid.inspect} should not be valid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email=@user.email.upcase!
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should not be blank" do
      @user.password= "      "
      @user.password_confirmation = "      "
      assert_not @user.valid?
  end

  test "password should be at least 6 letters" do
      @user.password = @user.password_confirmation = "12345"
      assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated posts should be deleted too" do
    @user.save
    @user.microposts.create!(content:"kjfgsdlkj")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

end
