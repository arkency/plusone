class MessageParser
  def initialize(text, trigger_word)
    @text = text
    @trigger_word = trigger_word
  end

  def recipient_name
    extract_and_clean_first_word(extract_remaining_text)
  end

  private

  attr_accessor :text, :trigger_word

  def extract_remaining_text
    text[trigger_word.length..]
  end

  def extract_and_clean_first_word(remaining_text)
    first_word = remaining_text.strip.split.first
    first_word ? first_word.chomp(",") : ""
  end
end
