class MessageParser
  def initialize(text, trigger_word)
    self.text = text
    self.trigger_word = trigger_word
  end

  def first_recipient
    recipients.first || ''
  end

  def recipients
    beginning = trigger_word.size
    remaining = text[beginning..text.size-1]
    remaining.strip.split
  end

  private

  attr_accessor :text, :trigger_word
end
