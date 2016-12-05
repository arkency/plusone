class PrepareTransactionActors
  class MissingRecipient < StandardError ; end

  def initialize team, slack_adapter
    @team = team
    @slack_adapter = slack_adapter
  end

  def call(params)
    sender_username    = fetch_name(params[:user_name])
    recipients_usernames = fetch_recipients(params.slice(:text, :trigger_word)).map(&method(:fetch_name))

    raise MissingRecipient unless recipients_usernames.any?
    recipients = recipients_usernames.map { |name| prepare_team_member.call(@team, name) }

    sender    = prepare_team_member.call(@team, sender_username, params[:user_id])
    [sender, recipients]
  end

  private

  def fetch_name(name)
    clean_name(@slack_adapter.get_real_user_name(name))
  end

  def clean_name(name)
    name.gsub(/^(@+)/, "")
  end

  def fetch_recipients(text_params)
    MessageParser.new(text_params[:text], text_params[:trigger_word]).recipients
  end

  # def recipient_name(text_params)
  #   MessageParser.new(text_params[:text], text_params[:trigger_word]).first_recipient
  # end

  def prepare_team_member
    PrepareTeamMember.new
  end
end
