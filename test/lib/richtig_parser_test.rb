# frozen_string_literal: true

require "test_helper"
require "richtig_parser"

class RichtigParserTest < ActiveSupport::TestCase
  def test_explore_parslet
    assert_equal({ plus_one: "+1", alias_keyword: "!alias", username: "super", user_alias: "@johndoe" }, parse("+1 !alias super @johndoe"))
    assert_equal({ plus_one: "+1", alias_keyword: "!alias", username: "super", user_alias: "@johndoe" }, parse("+1!aliassuper@johndoe"))
  end

  def parse(text)
    Richtig.parse(text)
  end
end
