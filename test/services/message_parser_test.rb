require 'test_helper'

class MessageParserTest < ActiveSupport::TestCase

  test "first_recipient returns first recipient from message" do
    recipient = service.first_recipient
    assert_equal(username1, recipient)
  end 

  test "recipients returns recipients names in array" do
    recipients = service.recipients
    assert_equal([username1, username2], recipients)
  end

  test "first_recipient returns empty string if it doesnt have recipient" do
    service = MessageParser.new("+1", trigger_word)
    recipient = service.first_recipient
    assert_equal("", recipient)
  end

  private

  def service
    service = MessageParser.new(text, trigger_word)
  end

  def trigger_word
    "+1"
  end

  def text 
    "+1 #{username1} #{username2}"
  end

  def username1
    '<@username1>'
  end

  def username2
    '<@username2>'
  end
end
