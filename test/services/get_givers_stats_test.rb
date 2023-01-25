require "test_helper"

class GetGiversStatsTest < ActiveSupport::TestCase
  test "returns statistics" do
    team = PrepareTeam.new.call(team_id, team_domain)
    member1 =
      team.team_members.create!(slack_user_name: "user_name", points: 666)
    member2 =
      team.team_members.create!(slack_user_name: "user_name2", points: 2)
    Upvote.create(sender: member1, recipient: member2)
    Upvote.create(sender: member1, recipient: member2)
    Upvote.create(sender: member2, recipient: member1)

    assert_equal <<~RESULT.strip, stats.given(team_id, team_domain)
      2: user_name
      1: user_name2
    RESULT
  end

  test "returns empty string when no team_members present" do
    assert_equal "", stats.given(team_id, team_domain)
  end

  private

  def stats
    Stats.new
  end

  def team_domain
    "team1"
  end

  def team_id
    "team_id1"
  end
end
