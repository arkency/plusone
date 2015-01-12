class UsernameFetcher
  NoUserInSlack = Class.new(StandardError)

  def call(user_tag)
    user_tag = parse_user_tag(user_tag)
    slack_user_info(user_tag)
  rescue NoUserInSlack
    username_from_tag(user_tag)
  end

  private
  def parse_user_tag(user_tag)
    user_tag[2..-2]
  end

  def slack_user_info(user_tag)
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
        token: 'xoxp-2181345045-2321579527-3389973901-7ff25a',
        user: user_tag
    }
    uri.query = URI.encode_www_form(params)
    uri
  end

  def username_from_tag(user_tag)
    user_tag.slice(0).downcase
  end
end