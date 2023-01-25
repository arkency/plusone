require "test_helper"

class InMemorySlackAdapterTest < ActiveSupport::TestCase
  test "returns same username when it doesnt start with <@" do
    slack_adapter = InMemorySlackAdapter.new
    assert_equal "user_name", slack_adapter.get_real_user_name(valid_token, "user_name")
  end

  test "returns u when user_name stats with <@ and token is not valid" do
    slack_adapter = InMemorySlackAdapter.new
    assert_equal "u", slack_adapter.get_real_user_name(invalid_token, "<@user_name>")
  end

  test "returns username without <@ when token is valid" do
    slack_adapter = InMemorySlackAdapter.new
    assert_equal "user_name", slack_adapter.get_real_user_name(valid_token,  "<@user_name>")
  end

  private

  def valid_token
    "valid"
  end

  def invalid_token
    "invalid"
  end
end
