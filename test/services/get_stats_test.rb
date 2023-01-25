require "test_helper"

class GetStatsTest < ActiveSupport::TestCase
  test "returns statistics" do
    team = PrepareTeam.new.call(team_id, team_domain)
    team.team_members.create!(slack_user_name: "user_name", points: 666)
    team.team_members.create!(slack_user_name: "user_name2", points: 666)
    team.team_members.create!(slack_user_name: "user_name3", points: 2)

    assert_equal <<~RESULT.strip,  stats.received(team_id, team_domain)
      666: user_name, user_name2
      2: user_name3
    RESULT
  end

  test "returns empty string when no team_members present" do
    assert_equal "", stats.received(team_id, team_domain)
  end

  private

  def stats
    Stats.new
  end

  def team_id
    "team_id1"
  end

  def team_domain
    "team1"
  end
end
