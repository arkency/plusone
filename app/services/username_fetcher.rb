class UsernameFetcher
  NoUserInSlack = Class.new(StandardError)

  def call(user_tag, team_slack_token)
    @team_slack_token = team_slack_token
    if slack_username?(user_tag)
      fetch_slack_username(user_tag)
    else
      user_tag
    end
  rescue NoUserInSlack
    slack_bot_username(user_tag)
  end

  private
  def slack_username?(user_tag)
    user_tag.start_with?("<@")
  end

  def fetch_slack_username(user_tag)
    user_tag = strip_slack_user_tag(user_tag)
    json = call_slack(user_tag)
    raise NoUserInSlack unless json["ok"]
    json["user"]["name"]
  end

  def call_slack(user_tag)
    uri = build_uri(user_tag)
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end

  def build_uri(user_tag)
    uri = URI('https://slack.com/api/users.info')
    params = {
        token: @team_slack_token,
        user: user_tag
    }
    uri.query = URI.encode_www_form(params)
    uri
  end

  def strip_slack_user_tag(user_tag)
    user_tag[2..-2]
  end

  def slack_bot_username(user_tag)
    strip_slack_user_tag(user_tag).slice(0).downcase
  end
end