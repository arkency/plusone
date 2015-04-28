class PrepareTransactionActors
  class MissingRecipient < StandardError ; end

  def call(team_params, text_params, user_params)
    team = prepare_team(team_params)

    sender_username    = fetch_name(user_params[:user_name])
    recipient_username = fetch_name(recipient_name(text_params))

    raise MissingRecipient unless recipient_username.present?

    sender    = prepare_sender(team, sender_username, user_params[:user_id])
    recipient = prepare_recipient(team, recipient_username)
    [sender, recipient]
  end

  private
  attr_reader :username_fetcher

  def prepare_team(team_params)
    prepare_team_service.(team_params)
  end

  def fetch_name(name)
    clean_name(username_fetcher.(name))
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

  def prepare_team_service
    PrepareTeam.new
  end

  def username_fetcher
    @username_fetcher ||= UsernameFetcher.new
  end
end