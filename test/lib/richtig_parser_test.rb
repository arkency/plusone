# frozen_string_literal: true

require "test_helper"
require "richtig_parser"

class RichtigParserTest < ActiveSupport::TestCase
  def test_explore_parslet
      assert_equal({ trigger: "+1", alias_keyword: "!alias", username: "super", user_alias: "<@U029FG7VA>" }, parse("+1 !alias super <@U029FG7VA>"))
      assert_equal({ trigger: "+1", alias_keyword: "!alias", username: "super", user_alias: "<@U029FG7VA>" }, parse("+1!aliassuper<@U029FG7VA>"))
  end

  def test_with_different_trigger_word
    assert_equal({ trigger: "dej plusika dla", alias_keyword: "!alias", username: "super", user_alias: "<@U029FG7VA>" }, parse("dej plusika dla !alias super <@U029FG7VA>", "dej plusika dla"))
    assert_equal({ trigger: "dej plusika dla", alias_keyword: "!alias", username: "super", user_alias: "<@U029FG7VA>" }, parse("dej plusika dla!aliassuper<@U029FG7VA>", "dej plusika dla"))
  end

  def parse(text, trigger_word = "+1")
    Richtig.parse(text, trigger_word)
  end
end
