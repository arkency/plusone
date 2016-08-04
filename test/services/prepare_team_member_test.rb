require 'test_helper'

class PrepareTeamMemberTest < ActiveSupport::TestCase

  test "creates team_member if doesnt exist" do
    team = PrepareTeam.new.call(team_params)
    user_name = "user_name"
    user_id = "user_id"

    member = TeamMember.where(slack_user_name: user_name).first
    assert(member.nil?)

    PrepareTeamMember.new.call(team, user_name, user_id)

    member = TeamMember.where(slack_user_name: user_name).first
    assert_not_nil(member)

  end

  private

  def team_params
    { team_id: "team_id", team_domain: "team_domain" }
  end

end
