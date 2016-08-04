class InMemorySlackAdapter

  def initialize(team_slack_token)
    @team_slack_token = team_slack_token
  end

  def get_real_user_name(user_tag)
    if slack_username?(user_tag)
      fetch_slack_username(user_tag)
    else
      user_tag
    end
  end

  def fetch_slack_username(user_tag)
    @team_slack_token == 'valid' ? user_tag[2..-2] : 'u'
  end

  def slack_username?(user_tag)
    user_tag.start_with?("<@")
  end

end
