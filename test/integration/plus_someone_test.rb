require "test_helper"

class PlusSomeoneTest < ActionDispatch::IntegrationTest
  cover SlackController

  def test_add_points_for_nonexisting_team_see_stats
    add_points
    assert_team_exists_in_an_ugly_way_until_we_fix_api
    see_stats
    see_givers
    add_points
    see_stats_after_second_plusone
    see_givers_after_second_plusone
  end

  test "return information about missing slack_token when user with @ specified" do
    post "/slack/plus",
         params: {
           team_domain: "team1",
           trigger_word: "+1",
           text: "+1 <@user_name2>",
           team_id: "team_id1",
           user_name: "@user_name1",
           user_id: "<@user_id1>",
           format: :json,
         }

    assert_equal(
      response_text,
      "This slack team doesn't have specified slack token(or it's invalid). Please use nickname without @",
    )

    post "/slack/plus",
         params: {
           trigger_word: "+1",
           text: "+1 !stats",
           team_id: "team_id1",
           team_domain: "team1",
           format: :json,
         }

    assert_equal("", response_text)
  end

  test "doesnt increase points if sender is recipient" do
    post "/slack/plus",
         params: {
           team_domain: "team1",
           trigger_word: "+1",
           text: "+1 user_name1",
           team_id: "team_id1",
           user_name: "user_name1",
           user_id: "user_id1",
           format: :json,
         }

    assert_equal(response_text, "Nope... not gonna happen.")

    post "/slack/plus",
         params: {
           trigger_word: "+1",
           text: "+1 !stats",
           team_id: "team_id1",
           team_domain: "team1",
           format: :json,
         }

    assert_equal("", response_text)
  end

  test "returns instruction when recipient is empty" do
    post "/slack/plus",
         params: {
           team_domain: "team1",
           trigger_word: "+1",
           text: "+1",
           team_id: "team_id1",
           user_name: "user_name1",
           user_id: "user_id1",
           format: :json,
         }

    assert_equal(
      response_text,
      "PlusOne bot instruction:\n" + "-Use '+1 @name' if you want to appreciate someone\n" +
        "-Use '+1 !stats' to get statistics\n" + "-Use '+1 !givers' to get givers statistics\n" +
        "Want to help with PlusOne development? Feel welcome: https://github.com/arkency/plusone",
    )
  end

  private

  def assert_team_exists_in_an_ugly_way_until_we_fix_api
    assert Team.find_by(slack_team_domain: "team1", slack_team_id: "team_id1")
  end

  def see_stats
    post "/slack/plus",
         params: {
           trigger_word: "+1",
           text: "+1 !stats",
           team_id: "team_id1",
           team_domain: "team1",
           format: :json,
         }

    assert_equal("1: user_name2\n0: user_name1", response_text)
  end

  def see_stats_after_second_plusone
    post "/slack/plus",
         params: {
           trigger_word: "+1",
           text: "+1 !stats",
           team_id: "team_id1",
           team_domain: "team1",
           format: :json,
         }

    assert_equal("2: user_name2\n0: user_name1", response_text)
  end

  def see_givers
    post "/slack/plus",
         params: {
           trigger_word: "+1",
           text: "+1 !givers",
           team_id: "team_id1",
           team_domain: "team1",
           format: :json,
         }

    assert_equal("1: user_name1\n0: user_name2", response_text)
  end

  def see_givers_after_second_plusone
    post "/slack/plus",
         params: {
           trigger_word: "+1",
           text: "+1 !givers",
           team_id: "team_id1",
           team_domain: "team1",
           format: :json,
         }

    assert_equal("2: user_name1\n0: user_name2", response_text)
  end

  def add_points
    post "/slack/plus",
         params: {
           team_domain: "team1",
           trigger_word: "+1",
           text: "+1 user_name2",
           team_id: "team_id1",
           user_name: "user_name1",
           user_id: "user_id1",
           format: :json,
         }
  end
end
