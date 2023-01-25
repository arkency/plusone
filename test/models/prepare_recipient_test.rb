require "test_helper"

class PrepareRecipientTest < ActiveSupport::TestCase
  test "returns sender and recipient with name from slack in array" do
    team.update(slack_token: "valid")
    recipient =
      PrepareRecipient.new(InMemorySlackAdapter.new).call(
        team,
        "+1 <@username2>",
        trigger_word
      )

    assert_equal "username2", recipient.slack_user_name
  end

  test "returns recipient with sanitized name with dots" do
    recipient =
      PrepareRecipient.new(SlackAdapter.new).call(
        team,
        "+1 name.with.dots..",
        trigger_word
      )

    assert_equal "name.with.dots", recipient.slack_user_name
  end

  test "returns recipient with sanitized name with url format" do
    recipient =
      PrepareRecipient.new(SlackAdapter.new).call(
        team,
        "+1 <http://asd.com|asd.com>",
        trigger_word
      )

    assert_equal "asd.com", recipient.slack_user_name
  end

  private

  def team
    Team.register("team_id", "kakadudu")
  end

  def trigger_word
    "+1"
  end
end
