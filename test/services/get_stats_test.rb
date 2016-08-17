require 'test_helper'

class GetStatsTest < ActiveSupport::TestCase

  test "returns statistics" do
    team = PrepareTeam.new.call(team_params)
    team.team_members.create!(slack_user_id: "user_id",
                              slack_user_name: "user_name",
                              points: 666
                             )

    team.team_members.create!(slack_user_id: "user_id2",
                              slack_user_name: "user_name2",
                              points: 666
                             )
    team.team_members.create!(slack_user_id: "user_id3",
                              slack_user_name: "user_name3",
                              points: 2
                             )
    result = GetStats.new.call(team_params)
    expected_result = "666: user_name, user_name2\n2: user_name3"
    assert_equal(expected_result, result)
  end

  test "returns empty string when no team_members present" do
    result = GetStats.new.call(team_params)
    expected_result = ""
    assert_equal(expected_result, result)
  end


  def team_params
   { team_domain: "team1", team_id: "team_id1" }
  end
end
