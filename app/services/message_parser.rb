class MessageParser

  def initialize(text, trigger_word = nil)
    _, @recipient, *@reason_words = text.split
  end

  def recipient_name
    recipient || ''
  end

  def reason
    reason_words.join(' ')
  end

  private

  attr_accessor :recipient, :reason_words

end
