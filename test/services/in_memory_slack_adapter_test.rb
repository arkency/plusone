require "test_helper"

class InMemorySlackAdapterTest < ActiveSupport::TestCase
  test "returns same username when it doesnt start with <@" do
    slack_adapter = InMemorySlackAdapter.new
    user_name = "user_name"
    real_user_name = slack_adapter.get_real_user_name("valid", user_name)
    assert_equal(user_name, real_user_name)
  end

  test "returns u when user_name stats with <@ and token is not valid" do
    slack_adapter = InMemorySlackAdapter.new
    user_name = "<@user_name>"
    real_user_name = slack_adapter.get_real_user_name("invalid", user_name)
    assert_equal("u", real_user_name)
  end

  test "returns username without <@ when token is valid" do
    slack_adapter = InMemorySlackAdapter.new
    user_name = "<@user_name>"
    expected_user_name = "user_name"
    real_user_name = slack_adapter.get_real_user_name("valid", user_name)
    assert_equal(expected_user_name, real_user_name)
  end
end
