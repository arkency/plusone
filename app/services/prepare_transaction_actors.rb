class PrepareTransactionActors
  class MissingRecipient < StandardError ; end

  def initialize team
    @team = team
  end

  def call(params)

    sender_username    = fetch_name(params[:user_name])
    recipient_username = fetch_name(recipient_name(params.slice(:text, :trigger_word)))

    raise MissingRecipient unless recipient_username.present?

    sender    = prepare_sender(@team, sender_username, params[:user_id])
    recipient = prepare_recipient(@team, recipient_username)
    [sender, recipient]
  end

  private

  def fetch_name(name)
    clean_name(slack_adapter.(name, @team.slack_token))
  end

  def clean_name(name)
    name.gsub(/^(@+)/, "")
  end

  def recipient_name(text_params)
    MessageParser.new(text_params[:text], text_params[:trigger_word]).recipient_name
  end

  def prepare_sender(team, sender_username, user_id)
    sender = team.team_members.find_or_initialize_by(slack_user_name: sender_username)
    sender.slack_user_id = user_id
    sender.save!
    sender
  end

  def prepare_recipient(team, recipient_name)
    recipient = team.team_members.find_or_initialize_by(slack_user_name: recipient_name)
    recipient.save!
    recipient
  end

  def slack_adapter
    @slack_adapter ||= SlackAdapter.new
  end
end
