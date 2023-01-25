class GetGiversStats
  def call(team_id, team_domain)
    team = PrepareTeam.new.call(team_id, team_domain)
    data = fetch_data(team)
    format(data)
  end

  private

  def fetch_data(team)
    team
      .team_members
      .includes(:given_upvotes)
      .map do |x|
        { name: x.slack_user_name, given_upvotes: x.given_upvotes.length }
      end
  end

  def format(data)
    grouped_data = data.group_by { |x| x[:given_upvotes] }
    grouped_data
      .keys
      .sort
      .reverse_each
      .map do |key|
        members = grouped_data[key].map { |tm| tm[:name] }.join(", ")
        "#{key}: #{members}"
      end
      .join("\n")
  end
end
