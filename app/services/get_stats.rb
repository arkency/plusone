class GetStats
  def call(team_id, team_domain)
    team = PrepareTeam.new.call(team_id, team_domain)
    grouped_data = team.team_members.group_by(&:points)
    grouped_data
      .keys
      .sort
      .reverse_each
      .map do |key|
        members = grouped_data[key].map { |tm| tm.slack_user_name }.join(", ")
        "#{key}: #{members}"
      end
      .join("\n")
  end
end
