require "test_helper"

class AliasesTest < ActionDispatch::IntegrationTest
  cover SlackController
  cover AliasToUserTag
  cover SlackAliasMessageParser

  def test_only_allow_user_tags_as_aliases
    post "/slack/plus",
         params: webhook_params(
           trigger_word: "+1",
           text: "+1 user_name2",
           user_name: "user_name1",
           user_id: "user_id1",
         )

    alias_user_name("user_name2", "<@U026BA51D>")

    alias_user_name("user_name2", "new_alias")
    assert_equal("Invalid user tag", JSON(response.body)["text"])
  end

  def test_can_alias_different_users
    post "/slack/plus",
         params: webhook_params(
           trigger_word: "+1",
           text: "+1 user_name2",
           user_name: "user_name1",
           user_id: "user_id1",
         )

    alias_user_name("user_name1", "<@U055CC67F>")
    alias_user_name("user_name2", "<@U026BA51D>")
  end

  def test_can_alias_with_exotic_trigger_word
    post "/slack/plus",
         params: webhook_params(
           trigger_word: "+1",
           text: "+1 user_name2",
           user_name: "user_name1",
           user_id: "user_id1",
         )

    post "/slack/plus",
         params: webhook_params(
           text: "dej plusika dla !alias user_name2 <@U026BA51D>",
           trigger_word: "dej plusika dla",
         )

    assert_equal("<@U026BA51D> is now an alias to user_name2", JSON(response.body)["text"])
  end

  def test_alias_with_typo
    assert_raises ActionController::ParameterMissing do
      post "/slack/plus",
           params: webhook_params(
             text: "+1 !alien user_name2 <@U026BA51D>",
             trigger_word: "+1"
           )
    end
  end

  def test_stats_show_aliases_together
    post "/slack/plus",
         params: webhook_params(
           trigger_word: "+1",
           text: "+1 user_name2",
           user_name: "user_name1",
           user_id: "user_id1",
         )
    post "/slack/plus",
         params: webhook_params(
           trigger_word: "+1",
           text: "+1 !alias user_name2 <@U026BA51D>",
           user_name: "user_name1",
           user_id: "user_id1",
         )
    response_text = JSON(response.body)["text"]
    expected_response = "<@U026BA51D> is now an alias to user_name2"
    assert_equal(response_text, expected_response)
    post "/slack/plus",
         params: webhook_params(
           trigger_word: "+1",
           text: "+1 <@U026BA51D>",
           user_name: "user_name1",
           user_id: "user_id1",
         )
    response_text = JSON(response.body)["text"]
    expected_response = "user_name1(0) gave +1 for user_name2(2)"
    assert_equal(response_text, expected_response)

    post "/slack/plus",
         params: webhook_params(
           trigger_word: "+1",
           text: "+1 !stats",
         )
    response_text = JSON(response.body)["text"]
    expected_response = "2: user_name2\n0: user_name1"
    assert_equal(expected_response, response_text)
  end

  def test_cant_alias_existing_alias
    post "/slack/plus",
         params: webhook_params(
           trigger_word: "+1",
           text: "+1 user_name2",
           user_name: "user_name1",
           user_id: "user_id1",
         )
    alias_user_name("user_name2", "<@U026BA51D>")
    assert_raises AliasToUserTag::AlreadyExists do
      alias_user_name("user_name2", "<@U026BA51D>")
    end
  end

  def test_cant_plusone_your_own_alias
    post "/slack/plus",
         params: webhook_params(
           trigger_word: "+1",
           text: "+1 user_name2",
           user_name: "user_name1",
           user_id: "user_id1",
         )
    alias_user_name("user_name2", "<@U026BA51D>")
    post "/slack/plus",
         params: webhook_params(
           trigger_word: "+1",
           text: "+1 <@U026BA51D>",
           user_name: "user_name2",
           user_id: "user_id2",
         )
    response_text = JSON(response.body)["text"]
    expected_plus_response = "Nope... not gonna happen."
    assert_equal(response_text, expected_plus_response)
  end

  private

  def alias_user_name(username, user_alias)
    post "/slack/plus",
         params: webhook_params(
           text: "+1 !alias #{username} #{user_alias}",
           trigger_word: "+1",
         )
  end

  def webhook_params(params)
    params.reverse_merge(
      {
        team_domain: "team1",
        team_id: "team_id1",
        format: :json
      }
    )
  end
end
