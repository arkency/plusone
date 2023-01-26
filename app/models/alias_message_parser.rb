class AliasMessageParser
  def initialize(text, trigger_word)
    @text = text
    @trigger_word = trigger_word
  end

  def user_name
    username_alias.first
  end

  def aliass
    username_alias.last
  end

  private
  def username_alias
    beginning = @trigger_word.size + " !alias".size
    remaining = @text.at(beginning..)
    remaining.split
  end
end
