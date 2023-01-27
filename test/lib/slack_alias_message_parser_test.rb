# frozen_string_literal: true

require "test_helper"
require "slack_alias_message_parser"

class SlackAliasMessageParserTest < ActiveSupport::TestCase
  cover SlackAliasMessageParser

  def test_parses_from_message_to_hash_for_given_trigger_word
    assert_equal({ trigger: "+1", alias_keyword: "!alias", username: "super", user_alias: "<@U029FG7VA>" }, parse("+1 !alias super <@U029FG7VA>"))
    assert_equal({ trigger: "+1", alias_keyword: "!alias", username: "super", user_alias: "<@U029FG7VA>" }, parse("+1!aliassuper<@U029FG7VA>"))
    assert_equal({ trigger: "dej plusika dla", alias_keyword: "!alias", username: "super", user_alias: "<@U029FG7VA>" }, parse("dej plusika dla !alias super <@U029FG7VA>", "dej plusika dla"))
    assert_equal({ trigger: "dej plusika dla", alias_keyword: "!alias", username: "super", user_alias: "<@U029FG7VA>" }, parse("dej plusika dla!aliassuper<@U029FG7VA>", "dej plusika dla"))
  end

  private

  def parse(text, trigger_word = "+1")
    SlackAliasMessageParser.parse(text, trigger_word)
  end
end
