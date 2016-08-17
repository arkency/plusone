class GetStats
  def call(team_params)
    team = PrepareTeam.new.call(team_params)
    data = fetch_data(team)
    format(data)
  end

  private

  def fetch_data team
    team.team_members
  end

  def format data
    grouped_data = data.group_by(&:points)
    grouped_data.keys.sort.reverse_each.map do |key|
       members = grouped_data[key].map { |tm| tm.slack_user_name }.join(', ')
       "#{key}: #{members}"
     end.join("\n")
  end
end
