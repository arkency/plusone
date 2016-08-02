require 'test_helper'

class PlusOneTest < ActiveSupport::TestCase

  test "pluses someone with valid params" do
    team = PrepareTeam.new.call(team_params)
    PlusOne.new.call(team, plus_params)

    result = GetStats.new.call(team_params)
    expected_result = "user_name2: 1, user_name1: 0"
    assert(result, expected_result)
  end

  test "raises exception when try to plus one yourself" do
    team = PrepareTeam.new.call(team_params)
    assert_raises PlusOne::CannotPlusOneYourself do
      PlusOne.new.call(team, invalid_plus_params)
    end

    result = GetStats.new.call(team_params)
    expected_result = ""
    assert(result, expected_result)
  end

  def team_params
    { team_id: "team_id", team_domain: "team_domain" }
  end

  def text_params
    { text: "+1 user_name2", trigger_word: "+1" }
  end

  def user_params
    { user_id: "user_id1", user_name: "user_name1" }
  end

  def plus_params
    text_params.merge(user_params)
  end

  def invalid_plus_params
    plus_params.merge(user_name: "user_name2")
  end

end
