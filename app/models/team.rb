class Team < ActiveRecord::Base
  has_many :team_members
end
