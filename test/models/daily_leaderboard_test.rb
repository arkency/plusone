require "test_helper"

class DailyLeaderboardTest < ActiveSupport::TestCase
  test "Daily leaderboard gets created on upvote event" do
    team = Team.register("external_id", "arkency")

    GiveUpvote.new.call("Albert", "+1 Alfred", "+1", team)
    record = DailyLeaderboard.last

    assert_equal 1, DailyLeaderboard.count
    assert_equal record.user_name, "Alfred"
    assert_equal record.points, 1
  end

  test "Daily leaderboard gets updated on upvote event" do
    team = Team.register("external_id", "arkency")
    GiveUpvote.new.call("Albert", "+1 Alfred", "+1", team)

    GiveUpvote.new.call("Albert", "+1 Alfred", "+1", team)
    record = DailyLeaderboard.last

    assert_equal 1, DailyLeaderboard.count
    assert_equal record.user_name, "Alfred"
    assert_equal record.points, 2
  end
end
