class Leaderboards
  def initialize(team)
    @team_id = Integer(team.id)
    @team_time_zone = team.time_zone
  end

  def top_for_this_week
    DailyLeaderboard
      .for_this_week(@team_time_zone)
      .top.of_team(@team_id)
      .group_by(&:points)
      .then(&method(:format))
  end

  def top_for_this_month
    DailyLeaderboard
      .for_this_month(@team_time_zone)
      .top.of_team(@team_id)
      .group_by(&:points)
      .then(&method(:format))
  end

  private

  def format(hash)
    hash
      .map { |count, members| "#{count}: #{members.map(&:user_name).join(", ")}" }
      .join("\n")
  end
end
