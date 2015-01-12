class ClearBadNicknames < ActiveRecord::Migration
  def change
    fetcher = UsernameFetcher.new
    TeamMember.all.each do |member|
      username = member.slack_user_name
      if username.length < 3
        member.destroy!
      elsif username.start_with?("<@")
        slack_name = fetcher.(username)
        real_person = TeamMember.where(slack_user_name: slack_name).first
        real_person.points = real_person.points + member.points if real_person
        real_person.save!
        member.destroy!
      end
    end
  end
end
