# frozen_string_literal: true

require "test_helper"

class AliasMessageParserTest < ActiveSupport::TestCase
  cover AliasMessageParser

  def test_parses_user_name
    assert_equal "user_name", parser("+1 !alias user_name @alias", plus_one).user_name
  end

  def test_parses_alias
    assert_equal "@alias", parser("+1 !alias user_name @alias", plus_one).aliass
  end

  def test_parses_alias_when_trigger_word_is_more_exotic
    assert_equal "@alias", parser("dej plusika dla !alias user_name @alias", exotic_trigger_word).aliass
  end

  def test_parses_username_when_trigger_word_is_more_exotic
    assert_equal "@alias", parser("dej plusika dla !alias user_name @alias", exotic_trigger_word).aliass
  end

  private

  def parser(text, trigger_word)
    AliasMessageParser.new(text, trigger_word)
  end

  def exotic_trigger_word
    "dej plusika dla"
  end

  def plus_one
    "+1"
  end
end
