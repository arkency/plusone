require "test_helper"

class LeaderboardsTest < ActiveSupport::TestCase
  test "leaderboards#top_for_this_month" do
    team = Team.register("external_id", "kakadudu")
    team.update(time_zone: 'Warsaw')

    travel_to(Time.now.in_time_zone('Warsaw').beginning_of_month.to_date - 1.day)
    GiveUpvote.new.call('dudu', '+1 kaka', '+1', team)
    travel_back
    GiveUpvote.new.call('dudu', '+1 kaka', '+1', team)
    GiveUpvote.new.call('dudu', '+1 kaka', '+1', team)
    GiveUpvote.new.call('kaka', '+1 dudu', '+1', team)

    assert_equal <<~RESULT.strip, Leaderboards.new(team).top_for_this_month
      2: kaka
      1: dudu
    RESULT
  end

  test "leaderboards#top_for_this_week" do
    team = Team.register("external_id", "kakadudu")
    team.update(time_zone: 'Warsaw')

    travel_to(Time.now.in_time_zone('Warsaw').beginning_of_week.to_date - 1.day)
    GiveUpvote.new.call('dudu', '+1 kaka', '+1', team)
    travel_back
    GiveUpvote.new.call('dudu', '+1 kaka', '+1', team)
    GiveUpvote.new.call('dudu', '+1 kaka', '+1', team)
    GiveUpvote.new.call('kaka', '+1 dudu', '+1', team)

    assert_equal <<~RESULT.strip, Leaderboards.new(team).top_for_this_week
      2: kaka
      1: dudu
    RESULT
  end
end
