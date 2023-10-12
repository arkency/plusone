class Leaderboards
  def initialize(team, limit = 10)
    @team_time_zone = team.time_zone
    @team_scope = DailyStatistic.of_team(team.id)
    @limit = limit
  end

  def top_for_this_week
    aggreated_data(@team_scope.for_this_week(@team_time_zone))
  end

  def top_for_this_month
    aggreated_data(@team_scope.for_this_month(@team_time_zone))
  end

  def top_for_this_year
    aggreated_data(@team_scope.for_this_year(@team_time_zone))
  end

  def top_for_month(year, month)
    aggreated_data(@team_scope.for_month(year, month, @team_time_zone))
  end

  def top_for_year(year)
    aggreated_data(@team_scope.for_year(year, @team_time_zone))
  end

  private

  def aggreated_data(scope)
    scope
      .group('user_name')
      .order('sum_points desc')
      .limit(@limit)
      .sum('points')
      .group_by(&:second)
      .map { |points, members| [points, members.map(&:first)] }.to_h
  end

  class TextPresenter
    def initialize(leaderboards)
      @leaderboards = leaderboards
    end

    def method_missing(m, *args, &block)
      @leaderboards.respond_to?(m) ? format(@leaderboards.public_send(m)) : super
    end

    private

    def format(hash)
      hash
        .map { |count, members| "#{count}: #{members.join(", ")}" }
        .join("\n")
    end
  end
end
