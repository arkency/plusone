class MessageParser
  def initialize(text, trigger_word)
    @text = text
    @trigger_word = trigger_word
  end

  def recipient_name
    beginning = trigger_word.size
    remaining = text[beginning..text.size - 1]
    remaining.strip.split.first&.chomp(",") || ""
  end

  private

  attr_accessor :text, :trigger_word
end
