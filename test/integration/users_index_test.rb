require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:red)
    @non_admin = users(:blue)
    @not_activated_user = users(:green)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template "users/index"
    assert_select "div.pagination"
    first_page_of_users = User.where(activated: true).paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
      # skip if the user is admin, admins don't have delete link next to their user name
      unless user == @admin
        assert_select "a[href=?]", user_path(user), text: "Delete"
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'Delete', count: 0
  end

  test "index when not activated" do
    log_in_as(@non_admin)
    get users_path
    assert_select "li", text: @not_activated_user.name, count: 0
  end

  test "should not show when not activated" do
    log_in_as(@not_activated_user)
    assert_not is_logged_in?
    get user_path(@not_activated_user)
    assert_redirected_to root_url
  end
end
