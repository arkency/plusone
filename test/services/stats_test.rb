require "test_helper"

class StatsTest < ActiveSupport::TestCase
  test "given upvotes" do
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

  test "given upvotes when no team_members present" do
    assert_equal "", stats.given(team_id, team_domain)
  end

  test "received upvotes" do
    team = PrepareTeam.new.call(team_id, team_domain)
    team.team_members.create!(slack_user_name: "user_name", points: 666)
    team.team_members.create!(slack_user_name: "user_name2", points: 666)
    team.team_members.create!(slack_user_name: "user_name3", points: 2)

    assert_equal <<~RESULT.strip,  stats.received(team_id, team_domain)
      666: user_name, user_name2
      2: user_name3
    RESULT
  end

  test "received upvotes when no team_members present" do
    assert_equal "", stats.received(team_id, team_domain)
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
