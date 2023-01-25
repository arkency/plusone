class Team < ActiveRecord::Base
  has_many :team_members

  def self.register(external_id, domain)
    find_or_initialize_by(slack_team_id: external_id).tap do |team|
      team.slack_team_domain = domain
      team.save!
    end
  end
end
