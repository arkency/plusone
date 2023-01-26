# frozen_string_literal: true

require "test_helper"
require "richtig_parser"

class RichtigParserTest < ActiveSupport::TestCase
  def test_explore_parslet
      assert_equal({ plus_one: "+1", alias_keyword: "!alias", username: "super", user_alias: "<@U029FG7VA>" }, parse("+1 !alias super <@U029FG7VA>"))
      assert_equal({ plus_one: "+1", alias_keyword: "!alias", username: "super", user_alias: "<@U029FG7VA>" }, parse("+1!aliassuper<@U029FG7VA>"))
  end

  def parse(text)
    Richtig.parse(text)
  end
end
