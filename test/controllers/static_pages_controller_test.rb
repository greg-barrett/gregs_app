require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base="For Gregs App"
  end

  test "should get home" do
    get root_url
    assert_response :success
    assert_select 'title', "#{@base}"
  end

  test "should get help" do
    get help_url
    assert_response :success
    assert_select 'title', "Help | #{@base}"
  end

  test "should get About" do
    get about_url
    assert_response :success
    assert_select 'title', "About | #{@base}"
  end

  test "should get contacts" do
    get contact_url
    assert_response :success
    assert_select 'title', "Contact | #{@base}"
  end

end
