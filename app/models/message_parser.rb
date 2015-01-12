class MessageParser
  def initialize(text, trigger_word)
    self.text = text
    self.trigger_word = trigger_word
  end

  def recipient_name
    beginning = trigger_word.size
    remaining = text[beginning..text.size-1]
    remaining.strip.split.first || ""
  end

  private

  attr_accessor :text, :trigger_word
end
