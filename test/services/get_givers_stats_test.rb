require "test_helper"

class GetGiversStatsTest < ActiveSupport::TestCase
  test "returns statistics" do
    team =
      PrepareTeam.new.call(team_params[:team_id], team_params[:team_domain])
    member1 =
      team.team_members.create!(
        slack_user_id: "user_id",
        slack_user_name: "user_name",
        points: 666
      )

    member2 =
      team.team_members.create!(
        slack_user_id: "user_id2",
        slack_user_name: "user_name2",
        points: 2
      )

    Upvote.create(sender: member1, recipient: member2)
    Upvote.create(sender: member1, recipient: member2)
    Upvote.create(sender: member2, recipient: member1)
    result = GetGiversStats.new.call(team_params)
    expected_result = "2: user_name\n1: user_name2"
    assert_equal(expected_result, result)
  end

  test "returns empty string when no team_members present" do
    result = GetGiversStats.new.call(team_params)
    expected_result = ""
    assert_equal(expected_result, result)
  end

  def team_params
    { team_domain: "team1", team_id: "team_id1" }
  end
end
