class GetStats
  def call(team_params)
    team = PrepareTeam.new.call(team_params)
    data = fetch_data(team)
    format(data)
  end

  private

  def fetch_data team
    team.team_members.order('team_members.points DESC')
  end

  def format data
    data.map{|tm| "#{tm.slack_user_name}: #{tm.points}"}.join(", ")
  end

end
