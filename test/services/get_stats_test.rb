require "test_helper"

class GetStatsTest < ActiveSupport::TestCase
  test "returns statistics" do
    team =
      PrepareTeam.new.call(team_id, team_domain)
    team.team_members.create!(
      slack_user_name: "user_name",
      points: 666
    )

    team.team_members.create!(
      slack_user_name: "user_name2",
      points: 666
    )
    team.team_members.create!(
      slack_user_name: "user_name3",
      points: 2
    )
    result = GetStats.new.call(team_id, team_domain)
    expected_result = "666: user_name, user_name2\n2: user_name3"
    assert_equal(expected_result, result)
  end

  test "returns empty string when no team_members present" do
    result = GetStats.new.call(team_id, team_domain)
    expected_result = ""
    assert_equal(expected_result, result)
  end

  private

  def team_id
    "team_id1"
  end

  def team_domain
    "team1"
  end
end
