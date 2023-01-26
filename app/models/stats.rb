class Stats
  def initialize(team_id)
    @team_id = Integer(team_id)
  end

  def received_upvotes
    TeamMember
      .where(team_id: @team_id)
      .left_joins(:received_upvotes)
      .select("COUNT(recipient_id) AS count, slack_user_name AS name")
      .group("slack_user_name")
      .order("COUNT(recipient_id) DESC")
      .group_by(&:count)
      .then(&method(:format))
  end

  def given_upvotes
    TeamMember
      .where(team_id: @team_id)
      .left_joins(:given_upvotes)
      .select("COUNT(sender_id) AS count, slack_user_name AS name")
      .group("slack_user_name")
      .order("COUNT(sender_id) DESC")
      .group_by(&:count)
      .then(&method(:format))
  end

  private

  def format(hash)
    hash
      .map do |count, members|
        "#{count}: #{members.map(&:name).join(", ")}"
      end
      .join("\n")
  end
end
