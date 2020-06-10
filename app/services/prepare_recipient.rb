class PrepareRecipient
  class MissingRecipient < StandardError ; end
  class InvalidSlackToken < StandardError; end

  def initialize(team, slack_adapter)
    @team = team
    @slack_adapter = slack_adapter
  end

  def call(params)
    recipient_username = fetch_name(recipient_name(params.slice(:text, :trigger_word)))
    raise MissingRecipient unless recipient_username.present?
    recipient = prepare_recipient(recipient_username)
    recipient_name = MessageParser.new(params[:text], params[:trigger_word]).recipient_name
    if Alias.exists?(user_alias: recipient_name)
      recipient = @team.team_members.find_by(slack_user_name: Alias.find_by(user_alias: recipient_name).username)
    end
    raise InvalidSlackToken if user_tag_which_is_not_an_alias?(recipient, recipient_name)
    recipient
  end

  private

  def user_tag_which_is_not_an_alias?(recipient, recipient_name)
    (recipient.slack_user_name == 'u') && ! Alias.exists?(user_alias: recipient_name)
  end

  def fetch_name(name)
    clean_name(@slack_adapter.get_real_user_name(name))
  end

  def clean_name(name)
    name.gsub(/^(@+)/, "")
  end

  def recipient_name(text_params)
    MessageParser.new(text_params[:text], text_params[:trigger_word]).recipient_name
  end

  def prepare_recipient(user_name)
    member = @team.team_members.find_or_initialize_by(slack_user_name: user_name)
    member.save!
    member
  end
end