class GetGiversStats
  def call(team_params)
    team = PrepareTeam.new.call(team_params)
    data = fetch_data(team)
    format(data)
  end

  private

  def fetch_data team
    team.team_members.includes(:given_pluses).map do |x| 
      {
        name: x.slack_user_name,
        given_pluses: x.given_pluses.length
      }
    end
  end

  def format data
    grouped_data = data.group_by { |x| x[:given_pluses] }
    grouped_data.keys.sort.reverse_each.map do |key|
       members = grouped_data[key].map{ |tm| tm[:name] }.join(', ')
       "#{key}: #{members}"
     end.join("\n")
  end
end
