require "test_helper"

class PrepareTransactionActorsTest < ActiveSupport::TestCase
  test "returns sender and recipient with name from slack in array" do
    team.register_member(user_name)
    team.update(slack_token: "valid")
    sender = team.register_member(user_name)
    recipient =
      PrepareRecipient.new(InMemorySlackAdapter.new).call(
        team.slack_team_id,
        "+1 <@username2>",
        trigger_word
      )

    assert_equal "username", sender.slack_user_name
    assert_equal "username2", recipient.slack_user_name
  end

  test "returns recipient with sanitized name with dots" do
    team.update(slack_token: "valid")
    recipient =
      PrepareRecipient.new(SlackAdapter.new).call(
        team.slack_team_id,
        "+1 name.with.dots..",
        trigger_word
      )

    assert_equal "name.with.dots", recipient.slack_user_name
  end

  test "returns recipient with sanitized name with url format" do
    team.update(slack_token: "valid")
    recipient =
      PrepareRecipient.new(SlackAdapter.new).call(
        team.slack_team_id,
        "+1 <http://asd.com|asd.com>",
        trigger_word
      )

    assert_equal "asd.com", recipient.slack_user_name
  end

  private

  def team
    Team.register("team_id", "kakadudu")
  end

  def user_name
    "username"
  end

  def trigger_word
    "+1"
  end
end
