# frozen_string_literal: true

require "test_helper"

class AliasMessageParserTest < ActiveSupport::TestCase
  cover AliasMessageParser

  def test_parses_user_name
    assert_equal "user_name", parser("+1 !alias user_name @alias").user_name
  end

  def test_parses_alias
    assert_equal "@alias", parser("+1 !alias user_name @alias").aliass
  end

  private

  def parser(text)
    AliasMessageParser.new(text, trigger_word)
  end

  def trigger_word
    "+1"
  end
end
