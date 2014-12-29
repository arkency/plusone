class MessageParser
  def initialize(text, trigger_word)
    self.text = text
    self.trigger_word = trigger_word
  end

  def recipient_name
    beginning = trigger_word.size
    remaining = text[beginning..text.size-1]
    name = remaining.strip.split.first || ""
    clean_name(name)
  end

  private

  attr_accessor :text, :trigger_word

  def clean_name(name)
    name.gsub(/^(@+)/, "")
  end
end
