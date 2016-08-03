require 'test_helper'

class GetStatsTest < ActiveSupport::TestCase

  test "returns statistics" do
    team = PrepareTeam.new.call(team_params)
    team.team_members.create!(slack_user_id: "user_id",
                              slack_user_name: "user_name",
                              points: 2
                             )
    
    result = GetStats.new.call(team_params)
    expected_result = "user_name: 2"
    assert_equal(result, expected_result)
  end

  test "returns empty string when no team_members present" do
    team = PrepareTeam.new.call(team_params)
    
    result = GetStats.new.call(team_params)
    expected_result = ""
    assert_equal(result, expected_result)
  end


  def team_params
   { team_domain: "team1", team_id: "team_id1" }
  end

end
