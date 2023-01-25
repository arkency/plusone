class PrepareRecipient
  MissingRecipient = Class.new(StandardError)
  InvalidSlackToken = Class.new(StandardError)

  def initialize(slack_adapter)
    @slack_adapter = slack_adapter
  end

  def call(team, text, trigger_word)
    recipient_name = recipient_name(text, trigger_word)
    recipient_username = fetch_name(team.slack_token, recipient_name)
    raise MissingRecipient unless recipient_username.present?

    if Alias.exists?(user_alias: recipient_name)
      recipient =
        team.team_members.find_by(
          slack_user_name: Alias.find_by(user_alias: recipient_name).username
        )
    else
      recipient = team.register_member(recipient_username)
    end
    if user_tag_which_is_not_an_alias?(recipient, recipient_name)
      raise InvalidSlackToken
    end
    recipient
  end

  private

  def user_tag_which_is_not_an_alias?(recipient, recipient_name)
    (recipient.slack_user_name == "u") &&
      !Alias.exists?(user_alias: recipient_name)
  end

  def fetch_name(team_slack_token, name)
    clean_name(@slack_adapter.get_real_user_name(team_slack_token, name))
  end

  def clean_name(name)
    name.gsub(/^(@+)/, "")
  end

  def recipient_name(text, trigger_word)
    MessageParser.new(text, trigger_word).recipient_name
  end
end
