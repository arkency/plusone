class AliasMessageParser
  def initialize(text, trigger_word)
    @text = text
    @trigger_word = trigger_word
  end

  def user_name
    beginning = @trigger_word.size + " !alias".size
    remaining = @text[beginning..@text.size - 1]
    remaining.strip.split.first
  end

  def aliass
    beginning = @trigger_word.size + " !alias".size
    remaining = @text[beginning..@text.size - 1]
    remaining.strip.split.second
  end
end
