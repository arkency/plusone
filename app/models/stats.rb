class Stats
  def initialize(team_id)
    @team_id = Integer(team_id)
  end

  def received_upvotes
    TeamMember
      .where(team_id: @team_id)
      .order("points DESC")
      .group_by(&:points)
      .then(&method(:format))
  end

  def given_upvotes
    TeamMember
      .where(team_id: @team_id)
      .includes(:given_upvotes)
      .sort_by { |tm| tm.given_upvotes.size }
      .reverse_each
      .group_by { |tm| tm.given_upvotes.size }
      .then(&method(:format))
  end

  private

  def format(hash)
    hash
      .map do |count, team_members|
        "#{count}: #{team_members.map(&:slack_user_name).join(", ")}"
      end
      .join("\n")
  end
end
