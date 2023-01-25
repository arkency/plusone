require "test_helper"

class PlusOneTest < ActiveSupport::TestCase
  cover PlusOne

  test "pluses someone with valid params" do
    PlusOne.new.call(
      user_name,
      text_message,
      trigger_word,
      team_id,
      team_domain
    )

    assert_equal <<~RESULT.strip, stats.received_upvotes
      1: user_name2
      0: user_name1
    RESULT
  end

  test "raises exception when try to plus one yourself" do
    assert_raises PlusOne::CannotPlusOneYourself do
      PlusOne.new.call(
        invalid_user_name,
        text_message,
        trigger_word,
        team_id,
        team_domain
      )
    end

    assert_equal "", stats.received_upvotes
  end

  def test_team_test
    PlusOne.new.call(
      user_name,
      text_message,
      trigger_word,
      team_id,
      team_domain
    )

    assert Team.find_by(slack_team_domain: team_domain)
  end

  private

  def stats
    Stats.new(team_id, team_domain)
  end

  def team_params
    { team_domain: team_domain, team_id: team_id }
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
