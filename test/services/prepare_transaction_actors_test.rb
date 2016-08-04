require 'test_helper'

class PrepareTransactionActorsTest < ActiveSupport::TestCase

  test "returns sender and recipient in array" do
    slack_adapter = InMemorySlackAdapter.new('valid')
    service = PrepareTransactionActors.new(team, slack_adapter)
    sender, recipient = service.call(service_params)
  end

  private

  def team_params
    { team_id: "team_id", team_domain: "team_domain" }
  end

  def team
    @team ||= PrepareTeam.new.call(team_params)
  end

  def service_params
    {
      user_name: "<@username@>",
      user_id: "user_id",
      trigger_word: "+1",
      text: "+1 <@username2@>"
    }
  end


end
