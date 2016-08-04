class PrepareTransactionActors
  class MissingRecipient < StandardError ; end

  def initialize team
    @team = team
  end

  def call(params)

    sender_username    = fetch_name(params[:user_name])
    recipient_username = fetch_name(recipient_name(params.slice(:text, :trigger_word)))

    raise MissingRecipient unless recipient_username.present?

    sender    = prepare_team_member.(@team, sender_username, params[:user_id])
    recipient = prepare_team_member.(@team, recipient_username)
    [sender, recipient]
  end

  private

  def fetch_name(name)
    clean_name(slack_adapter.(name))
  end

  def clean_name(name)
    name.gsub(/^(@+)/, "")
  end

  def recipient_name(text_params)
    MessageParser.new(text_params[:text], text_params[:trigger_word]).recipient_name
  end

  def prepare_team_member
    PrepareTeamMember.new
  end


  def slack_adapter
    @slack_adapter ||= SlackAdapter.new(@team.slack_token)
  end
end
