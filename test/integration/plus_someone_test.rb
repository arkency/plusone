require 'test_helper'

class PlusSomeoneTest < ActionDispatch::IntegrationTest
  cover "PlusOne"

  def test_add_points_for_nonexisting_team_see_stats
    add_points
    see_stats
    see_givers
    add_points
    see_stats_after_second_plusone
    see_givers_after_second_plusone
  end

  test "return information about missing slack_token when user with @ specified" do
    team_domain = "team1"
    team_id = "team_id1"
    sender_name = "@user_name1"
    sender_id = "<@user_id1>"
    recipient_name = "<@user_name2>"
    trigger_word = "+1"

    stats_params = {
      trigger_word: trigger_word,
      text: "#{trigger_word} !stats",
      team_id: team_id,
      team_domain: team_domain,
      format: :json
    }

    plus_params = {
      team_domain: team_domain,
      trigger_word: trigger_word,
      text: "#{trigger_word} #{recipient_name}",
      team_id: team_id,
      user_name: sender_name,
      user_id: sender_id,
      format: :json
    }

    post "/slack/plus", params: plus_params
    response_text = JSON(response.body)["text"]
    expected_response = "This slack team doesn't have specified slack token(or it's invalid). Please use nickname without @"
    assert_equal(response_text, expected_response)
    post "/slack/plus", params: stats_params
    response_text = JSON(response.body)["text"]
    expected_response = ""
    assert_equal(expected_response, response_text)
  end

  test "doesnt increase points if sender is recipient" do
    team_domain = "team1"
    team_id = "team_id1"
    sender_name = "user_name1"
    sender_id = "user_id1"
    trigger_word = "+1"

    stats_params = {
      trigger_word: trigger_word,
      text: "#{trigger_word} !stats",
      team_id: team_id,
      team_domain: team_domain,
      format: :json
    }

    plus_params = {
      team_domain: team_domain,
      trigger_word: trigger_word,
      text: "#{trigger_word} #{sender_name}",
      team_id: team_id,
      user_name: sender_name,
      user_id: sender_id,
      format: :json
    }

    post "/slack/plus", params: plus_params
    plus_response_text = JSON(response.body)["text"]
    expected_plus_response = "Nope... not gonna happen."
    assert_equal(plus_response_text, expected_plus_response)
    post "/slack/plus", params: stats_params
    response_text = JSON(response.body)["text"]
    expected_response = ""
    assert_equal(expected_response, response_text)
  end

  test "returns instruction when recipient is empty" do
    team_domain = "team1"
    team_id = "team_id1"
    sender_name = "user_name1"
    sender_id = "user_id1"
    trigger_word = "+1"

    plus_params = {
      team_domain: team_domain,
      trigger_word: trigger_word,
      text: trigger_word,
      team_id: team_id,
      user_name: sender_name,
      user_id: sender_id,
      format: :json
    }

    post "/slack/plus", params: plus_params
    plus_response_text = JSON(response.body)["text"]
    expected_plus_response =
      "PlusOne bot instruction:\n" +
      "-Use '+1 @name' if you want to appreciate someone\n" +
      "-Use '+1 !stats' to get statistics\n" +
      "-Use '+1 !givers' to get givers statistics\n" +
      "Want to help with PlusOne development? Feel welcome: https://github.com/arkency/plusone"
    assert_equal(plus_response_text, expected_plus_response)
  end
  private

  def see_stats
    post "/slack/plus", params: {
      trigger_word: "+1",
      text: "+1 !stats",
      team_id: "team_id1",
      team_domain: "team1",
      format: :json
    }
    response_text = JSON(response.body)["text"]
    expected_response = "1: user_name2\n0: user_name1"
    assert_equal(expected_response, response_text)
  end

  def see_stats_after_second_plusone
    post "/slack/plus", params: {
      trigger_word: "+1",
      text: "+1 !stats",
      team_id: "team_id1",
      team_domain: "team1",
      format: :json
    }
    response_text = JSON(response.body)["text"]
    expected_response = "2: user_name2\n0: user_name1"
    assert_equal(expected_response, response_text)
  end

  def see_givers
    post "/slack/plus", params: {
      trigger_word: "+1",
      text: "+1 !givers",
      team_id: "team_id1",
      team_domain: "team1",
      format: :json
    }
    response_text = JSON(response.body)["text"]
    expected_response = "1: user_name1\n0: user_name2"
    assert_equal(expected_response, response_text)
  end

  def see_givers_after_second_plusone
    post "/slack/plus", params: {
      trigger_word: "+1",
      text: "+1 !givers",
      team_id: "team_id1",
      team_domain: "team1",
      format: :json
    }
    response_text = JSON(response.body)["text"]
    expected_response = "2: user_name1\n0: user_name2"
    assert_equal(expected_response, response_text)
  end

  def add_points
    post "/slack/plus", params: {
      team_domain: "team1",
      trigger_word: "+1",
      text: "+1 user_name2",
      team_id: "team_id1",
      user_name: "user_name1",
      user_id: "user_id1",
      format: :json
    }
  end

end
