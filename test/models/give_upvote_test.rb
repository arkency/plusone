require "test_helper"

class GiveUpvoteTest < ActiveSupport::TestCase
  cover GiveUpvote

  test "pluses someone with valid params" do
    GiveUpvote.new.call(
      user_name,
      text_message,
      trigger_word,
      team
    )

    assert_equal <<~RESULT.strip, stats.received_upvotes
      1: user_name2
      0: user_name1
    RESULT
  end

  test "raises exception when try to plus one yourself" do
    assert_raises GiveUpvote::CannotUpvoteYourself do
      GiveUpvote.new.call(
        invalid_user_name,
        text_message,
        trigger_word,
        team
      )
    end

    assert_equal "", stats.received_upvotes
  end

  def test_team_test
    GiveUpvote.new.call(
      user_name,
      text_message,
      trigger_word,
      team
    )

    assert Team.find_by(slack_team_domain: team_domain)
  end

  private

  def stats
    Stats.new(team.id)
  end

  def team
    Team.register(team_id, team_domain)
  end

  def text_message
    "+1 user_name2"
  end

  def trigger_word
    "+1"
  end

  def team_domain
    "kakadudu"
  end

  def team_id
    "team_id"
  end

  def user_name
    "user_name1"
  end

  def invalid_user_name
    "user_name2"
  end

  def user_id
    "user_id1"
  end
end
