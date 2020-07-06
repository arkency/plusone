require 'test_helper'

class AliasesTest < ActionDispatch::IntegrationTest

  cover "PlusOne"

  def test_only_allow_user_tags_as_aliases
    post "/slack/plus", params: {
      team_domain: "team1",
      trigger_word: "+1",
      text: "+1 user_name2",
      team_id: "team_id1",
      user_name: "user_name1",
      user_id: "user_id1",
      format: :json
    }
    AliasToUserTag.new.call("user_name2", "<@U026BA51D>")
    assert_raises AliasNotAUserTag do
      AliasToUserTag.new.call("user_name2", "new_alias")
    end
  end

  def test_stats_show_aliases_together
    post "/slack/plus", params: {
      team_domain: "team1",
      trigger_word: "+1",
      text: "+1 user_name2",
      team_id: "team_id1",
      user_name: "user_name1",
      user_id: "user_id1",
      format: :json
    }
    #AliasToUserTag.new.call("user_name2", "<@U026BA51D>")
    post "/slack/plus", params: {
      team_domain: "team1",
      trigger_word: "+1",
      text: "+1 !alias user_name2 <@U026BA51D>",
      team_id: "team_id1",
      user_name: "user_name1",
      user_id: "user_id1",
      format: :json
    }
    response_text = JSON(response.body)["text"]
    expected_response = "<@U026BA51D> is now an alias to user_name2"
    assert_equal(response_text, expected_response)
    post "/slack/plus", params: {
      team_domain: "team1",
      trigger_word: "+1",
      text: "+1 <@U026BA51D>",
      team_id: "team_id1",
      user_name: "user_name1",
      user_id: "user_id1",
      format: :json
    }
    response_text = JSON(response.body)["text"]
    expected_response = "user_name1(0) gave +1 for user_name2(2)"
    assert_equal(response_text, expected_response)

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

  def test_cant_alias_existing_alias
    post "/slack/plus", params: {
      team_domain: "team1",
      trigger_word: "+1",
      text: "+1 user_name2",
      team_id: "team_id1",
      user_name: "user_name1",
      user_id: "user_id1",
      format: :json
    }
    AliasToUserTag.new.call("user_name2", "<@U026BA51D>")
    assert_raises AliasAlreadyExists do
      AliasToUserTag.new.call("user_name1", "<@U026BA51D>")
    end
  end

  def test_cant_plusone_your_own_alias
    post "/slack/plus", params: {
      team_domain: "team1",
      trigger_word: "+1",
      text: "+1 user_name2",
      team_id: "team_id1",
      user_name: "user_name1",
      user_id: "user_id1",
      format: :json
    }
    AliasToUserTag.new.call("user_name2", "<@U026BA51D>")
    post "/slack/plus", params: {
      team_domain: "team1",
      trigger_word: "+1",
      text: "+1 <@U026BA51D>",
      team_id: "team_id1",
      user_name: "user_name2",
      user_id: "user_id2",
      format: :json
    }
    response_text = JSON(response.body)["text"]
    expected_plus_response = "Nope... not gonna happen."
    assert_equal(response_text, expected_plus_response)
  end
end

