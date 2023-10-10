class DailyLeaderboard < ActiveRecord::Base
  self.table_name = 'daily_leaderboard'

  def self.rebuild_read_model!(event_store = Rails.configuration.event_store)
    DailyLeaderboard.delete_all
    event_store.read.of_type([UpvoteReceivedV2]).in_batches.each do |event|
      apply_upvote_received(event)
    end
  end

  def self.apply_upvote_received(event)
    team = Team.find(event.data.fetch(:team_id))
    return unless team.time_zone
    DailyLeaderboard.transaction do
      record = DailyLeaderboard.find_or_create_by!(
        user_name: TeamMember.find(event.data.fetch(:recipient_id)).slack_user_name,
        date: event.valid_at.in_time_zone(team.time_zone).to_date
      ).lock!
      record.increment!(:points)
    end
  end
end
