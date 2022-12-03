class PrepareRecipient
  class MissingRecipient < StandardError
  end
  class InvalidSlackToken < StandardError
  end

  def initialize(slack_adapter)
    @slack_adapter = slack_adapter
  end

  def call(team_id, params)
    team = Team.find_by(slack_team_id: team_id)
    recipient_username =
      fetch_name(
        team.slack_token,
        recipient_name(params.slice(:text, :trigger_word))
      )
    raise MissingRecipient unless recipient_username.present?
    recipient_name =
      MessageParser.new(params[:text], params[:trigger_word]).recipient_name
    if Alias.exists?(user_alias: recipient_name)
      recipient =
        team.team_members.find_by(
          slack_user_name: Alias.find_by(user_alias: recipient_name).username
        )
    else
      recipient = prepare_recipient(team, recipient_username)
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

  def recipient_name(text_params)
    MessageParser.new(
      text_params[:text],
      text_params[:trigger_word]
    ).recipient_name
  end

  def prepare_recipient(team, user_name)
    member = team.team_members.find_or_initialize_by(slack_user_name: user_name)
    member.save!
    member
  end
end
