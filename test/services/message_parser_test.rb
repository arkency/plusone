require 'test_helper'

class MessageParserTest < ActiveSupport::TestCase

  test "returns correct username and empty reason when not given" do
    trigger_word = "+1"
    recipient_name = "testuser"
    text = "#{trigger_word} #{recipient_name}"
    parser = MessageParser.new(text, trigger_word)
    result = parser.recipient_name
    assert_empty(parser.reason)
    assert_equal(result, recipient_name)
  end

  test "returns empty recipient_name when its not provided" do
    trigger_word = "+1"
    parser = MessageParser.new(trigger_word, trigger_word)
    result = parser.recipient_name
    assert_empty(result)
  end

  test "returns correct reason if given" do
    trigger_word = "+1"
    recipient_name = "testuser"
    reason = "for being nice to others"
    text = "#{trigger_word} #{recipient_name} #{reason}"
    parser = MessageParser.new(text, trigger_word)
    result = parser.reason
    assert_equal(reason, result)
  end

end
