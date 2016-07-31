namespace :team_members do
  desc "Fetches nicknames from slack API and saves them"
  task clear_bad_nicknames: :environment do

    fetcher = UsernameFetcher.new
    TeamMember.all.each do |member|
      username = member.slack_user_name
      team_slack_token = member.team.slack_token

      if username.length < 3
        member.destroy!
      elsif username.start_with?("<@")
        slack_name = fetcher.(username, team_slack_token)
        real_person = TeamMember.where(slack_user_name: slack_name).first
        real_person.points = real_person.points + member.points if real_person
        real_person.save!
        member.destroy!
      end
    end

  end

end
