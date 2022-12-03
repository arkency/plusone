class InMemorySlackAdapter
  def get_real_user_name(team_slack_token, user_tag)
    if slack_username?(user_tag)
      fetch_slack_username(team_slack_token, user_tag)
    else
      user_tag
    end
  end

  def fetch_slack_username(team_slack_token, user_tag)
    team_slack_token == "valid" ? user_tag[2..-2] : "u"
  end

  def slack_username?(user_tag)
    user_tag.start_with?("<@")
  end
end
