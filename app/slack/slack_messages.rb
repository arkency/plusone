class SlackMessages
  def self.cant_plus_one_yourself
    { text: "Nope... not gonna happen." }
  end

  def self.bot_instruction
    {
      text:
        "PlusOne bot instruction:\n" +
          "-Use '+1 @name' if you want to appreciate someone\n" +
          "-Use '+1 !stats' to get statistics\n" +
          "-Use '+1 !givers' to get givers statistics\n" +
          "Want to help with PlusOne development? Feel welcome: https://github.com/arkency/plusone"
    }
  end

  def self.invalid_slack_token
    {
      text:
        "This slack team doesn't have specified slack token(or it's invalid). Please use nickname without @"
    }
  end

  def self.alias_success(aliass, user_name)
    { text: "#{aliass} is now an alias to #{user_name}" }
  end
end
