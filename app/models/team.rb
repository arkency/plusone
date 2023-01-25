class Team < ActiveRecord::Base
  has_many :team_members

  def self.register(external_id, domain)
    team = find_or_initialize_by(slack_team_id: external_id)
    team.slack_team_domain = domain
    team.save!
    team
  end
end
