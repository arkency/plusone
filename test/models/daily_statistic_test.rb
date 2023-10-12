require "test_helper"

class DailyStatisticTest < ActiveSupport::TestCase
  test "Daily statistic gets created on upvote event" do
    team = Team.register("external_id", "arkency")
    team.update(time_zone: "Warsaw")

    GiveUpvote.new.call("Albert", "+1 Alfred", "+1", team)
    record = DailyStatistic.last

    assert_equal 1, DailyStatistic.count
    assert_equal record.user_name, "Alfred"
    assert_equal record.points, 1
  end

  test "Daily statistic gets updated on upvote event" do
    team = Team.register("external_id", "arkency")
    team.update(time_zone: "Warsaw")
    GiveUpvote.new.call("Albert", "+1 Alfred", "+1", team)

    GiveUpvote.new.call("Albert", "+1 Alfred", "+1", team)
    record = DailyStatistic.last

    assert_equal 1, DailyStatistic.count
    assert_equal record.user_name, "Alfred"
    assert_equal record.points, 2
  end

  test "Daily statistic feature currently requires teams.time_zone to be set" do
    team = Team.register("external_id", "arkency")

    GiveUpvote.new.call("Albert", "+1 Alfred", "+1", team)

    assert_equal 0, DailyStatistic.count
  end
end
