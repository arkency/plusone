class Stats
  def initialize(team_id)
    @team_id = team_id
  end

  def received_upvotes
    grouped_data = TeamMember.where(team_id: @team_id).group_by(&:points)
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

  def given_upvotes
    grouped_data =
      TeamMember.where(team_id: @team_id)
        .includes(:given_upvotes)
        .map do |x|
          { name: x.slack_user_name, given_upvotes: x.given_upvotes.length }
        end
        .group_by { |x| x[:given_upvotes] }
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
