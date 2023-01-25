class SlackMessages
  def self.raw(message)
    { text: message }
  end

  def self.cant_plus_one_yourself
    raw("Nope... not gonna happen.")
  end

  def self.bot_instruction
    raw(<<~EOS.strip)
      PlusOne bot instruction:
      -Use '+1 @name' if you want to appreciate someone
      -Use '+1 !stats' to get statistics
      -Use '+1 !givers' to get givers statistics
      Want to help with PlusOne development? Feel welcome: https://github.com/arkency/plusone
    EOS
  end

  def self.invalid_slack_token
    raw("This slack team doesn't have specified slack token(or it's invalid). Please use nickname without @")
  end

  def self.alias_success(aliass, user_name)
    raw("#{aliass} is now an alias to #{user_name}")
  end

  def self.slack_output_message(recipient, sender)
    raw("#{sender.slack_user_name}(#{sender.points}) gave +1 for #{recipient.slack_user_name}(#{recipient.points})").merge(parse: "none")
  end
end
