class Team < ActiveRecord::Base
  has_many :team_members

  def self.register(external_id, domain)
    find_or_initialize_by(slack_team_id: external_id).tap do |team|
      team.slack_team_domain = domain
      team.save!
    end
  end

  def register_member(user_name)
    team_members.find_or_create_by(slack_user_name: user_name)
  end
end
