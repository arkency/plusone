require 'test_helper'

class PlusSomeoneTest < ActionDispatch::IntegrationTest

  test "increases points for recipient" do
    team_domain = "team1"
    team_id = "team_id1"
    sender_name = "user_name1"
    sender_id = "user_id1"
    recipient_name = "user_name2"
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

    post "/slack/plus", plus_params
    post "/slack/plus", stats_params
    response_text = JSON(response.body)["text"]
    expected_response = "1: user_name2\n0: user_name1"
    assert_equal(expected_response, response_text)
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

    post "/slack/plus", plus_params
    response_text = JSON(response.body)["text"]
    expected_response = "This slack team doesn't have specified slack token(or it's invalid). Please use nickname without @"
    assert_equal(response_text, expected_response)
    post "/slack/plus", stats_params
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

    post "/slack/plus", plus_params
    plus_response_text = JSON(response.body)["text"]
    expected_plus_response = "Nope... not gonna happen."
    assert_equal(plus_response_text, expected_plus_response)
    post "/slack/plus", stats_params
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

    post "/slack/plus", plus_params
    plus_response_text = JSON(response.body)["text"]
    expected_plus_response =
      "PlusOne bot instruction:\n" +
      "-Use '+1 @name' if you want to appreciate someone\n" +
      "-Use '+1 !stats' to get statistics\n" +
      "Want to help with PlusOne development? Feel welcome: https://github.com/arkency/plusone"
    assert_equal(plus_response_text, expected_plus_response)
  end

end
