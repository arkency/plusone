require 'test_helper'

class PrepareTransactionActorsTest < ActiveSupport::TestCase

  test "returns sender and recipient with name from slack in array" do
    slack_adapter = InMemorySlackAdapter.new('valid')
    service = PrepareTransactionActors.new(team, slack_adapter)
    sender, recipient = service.call(service_params)
    assert_equal('username', sender.slack_user_name)
    assert_equal('username2', recipient.slack_user_name)
  end 
  
  test "returns recipient with sanitized name with dots" do
    slack_adapter = SlackAdapter.new('valid')
    service = PrepareTransactionActors.new(team, slack_adapter)
    sender, recipient = service.call(service_params.merge({text: '+1 name.with.dots..'}))
    assert_equal('name.with.dots', recipient.slack_user_name)
  end

  test "returns recipient with sanitized name with url format" do
    slack_adapter = SlackAdapter.new('valid')
    service = PrepareTransactionActors.new(team, slack_adapter)
    sender, recipient = service.call(service_params.merge({text: '+1 <http://asd.com|asd.com>'}))
    assert_equal('asd.com', recipient.slack_user_name)
  end
 
  private

  def team_params
    { team_id: "team_id", team_domain: "team_domain" }
  end

  def team
    @team ||= PrepareTeam.new.call(team_params[:team_id], team_params[:team_domain])
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
