require "test_helper"

class PlusOneTest < ActiveSupport::TestCase
  cover PlusOne

  test "pluses someone with valid params" do
    PlusOne.new.call(user_name, text_message, trigger_word, team_id, team_domain)

    result = GetStats.new.call(team_id, team_domain)
    expected_result = "1: user_name2\n0: user_name1"
    assert_equal(result, expected_result)
  end

  test "raises exception when try to plus one yourself" do
    assert_raises PlusOne::CannotPlusOneYourself do
      PlusOne.new.call(invalid_user_name, text_message, trigger_word, team_id, team_domain)
    end

    result = GetStats.new.call(team_id, team_domain)
    expected_result = ""
    assert_equal(result, expected_result)
  end

  def test_team_test
    PlusOne.new.call(user_name, text_message, trigger_word, team_id, team_domain)

    assert Team.find_by(slack_team_domain: team_domain)
  end

  private

  def team_params
{
      team_domain: team_domain,
      team_id: team_id
    }
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
