class Stats
  def initialize(external_id, domain)
    @team = Team.register(external_id, domain)
  end

  def received_upvotes
    grouped_data = @team.team_members.group_by(&:points)
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
      @team
        .team_members
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
