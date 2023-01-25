require "test_helper"

class StatsTest < ActiveSupport::TestCase
  test "given upvotes" do
    dudu.receive_upvote(kaka)
    dudu.receive_upvote(kaka)
    kaka.receive_upvote(dudu)

    assert_equal <<~RESULT.strip, stats.given_upvotes
      2: kaka
      1: dudu
    RESULT
  end

  test "given upvotes when no team_members present" do
    assert_equal "", stats.given_upvotes
  end

  test "received upvotes" do
    dudu.receive_upvote(kaka)
    dudu.receive_upvote(kaka)
    kaka.receive_upvote(dudu)

    assert_equal <<~RESULT.strip, stats.received_upvotes
      2: dudu
      1: kaka
    RESULT
  end

  test "received upvotes when no team_members present" do
    assert_equal "", stats.received_upvotes
  end

  private

  def kaka
    team.register_member("kaka")
  end

  def dudu
    team.register_member("dudu")
  end

  def team
    Team.register("external_id", "kakadudu")
  end

  def stats
    Stats.new(team.id)
  end
end
