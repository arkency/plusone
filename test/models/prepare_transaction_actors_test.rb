require "test_helper"

class PrepareTransactionActorsTest < ActiveSupport::TestCase
  test "returns sender and recipient with name from slack in array" do
    slack_adapter = InMemorySlackAdapter.new
    team.register_member(service_params[:user_name])
    team.update(slack_token: "valid")
    sender =
      PrepareSender.new.call(team.slack_team_id, service_params[:user_name])
    recipient =
      PrepareRecipient.new(slack_adapter).call(
        team.slack_team_id,
        service_params.fetch(:text),
        service_params.fetch(:trigger_word)
      )
    assert_equal("username", sender.slack_user_name)
    assert_equal("username2", recipient.slack_user_name)
  end

  test "returns recipient with sanitized name with dots" do
    slack_adapter = SlackAdapter.new
    team.update(slack_token: "valid")
    recipient =
      PrepareRecipient.new(slack_adapter).call(
        team.slack_team_id,
        service_params.merge({ text: "+1 name.with.dots.." }).fetch(:text),
        service_params.fetch(:trigger_word)
      )
    assert_equal("name.with.dots", recipient.slack_user_name)
  end

  test "returns recipient with sanitized name with url format" do
    slack_adapter = SlackAdapter.new
    team.update(slack_token: "valid")
    recipient =
      PrepareRecipient.new(slack_adapter).call(
        team.slack_team_id,
        service_params.merge({ text: "+1 <http://asd.com|asd.com>" }).fetch(
          :text
        ),
        service_params.fetch(:trigger_word)
      )
    assert_equal("asd.com", recipient.slack_user_name)
  end

  private

  def team
    Team.register("team_id", "kakadudu")
  end

  def service_params
    {
      user_name: "username",
      user_id: "user_id",
      trigger_word: "+1",
      text: "+1 <@username2>"
    }
  end
end
