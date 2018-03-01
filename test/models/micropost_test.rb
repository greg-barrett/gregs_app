require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user= users(:michael)
    @micropost= @user.microposts.build(content: "Hellooooooooooooooooooo")
  end

  test "valid post" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id= nil
    assert_not @micropost.valid?
  end

  test "Shouldn't be valid if over 140 characters" do
    content="a"*141
    @micropost.content=content
    assert_not @micropost.valid?
  end

  test "Content shouldn't be blank" do
    @micropost.content= " "
    assert_not @micropost.valid?
  end

  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
