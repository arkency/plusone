class PrepareTransactionActors
  class MissingRecipient < StandardError ; end

  def initialize team, slack_adapter
    @team = team
    @slack_adapter = slack_adapter
  end

  def call(params)
    sender_username    = params[:user_name]
    recipient_username = fetch_name(recipient_name(params.slice(:text, :trigger_word)))

    raise MissingRecipient unless recipient_username.present?

    sender    = prepare_sender(sender_username, params[:user_id])
    recipient = prepare_recipient(recipient_username)
    [sender, recipient]
  end

  private

  def fetch_name(name)
    clean_name(@slack_adapter.get_real_user_name(name))
  end

  def clean_name(name)
    name.gsub(/^(@+)/, "")
  end

  def recipient_name(text_params)
    MessageParser.new(text_params[:text], text_params[:trigger_word]).recipient_name
  end

  def prepare_sender(user_name, slack_id)
    member = @team.team_members.find_or_initialize_by(slack_user_name: user_name)
    member.slack_user_id = slack_id
    member.save!
    member
  end

  def prepare_recipient(user_name)
    member = @team.team_members.find_or_initialize_by(slack_user_name: user_name)
    member.save!
    member
  end
end
