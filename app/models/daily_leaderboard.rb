class DailyLeaderboard < ActiveRecord::Base
  self.table_name = 'daily_leaderboard'
  scope :by_period, -> (starting_date, duration) { where('date >= ? and date < ?', starting_date, starting_date + duration) }
  scope :for_this_week, -> (time_zone) { by_period(Time.now.in_time_zone(time_zone).beginning_of_week.to_date, 7.days) }
  scope :for_this_month, -> (time_zone) { by_period(Time.now.in_time_zone(time_zone).beginning_of_month.to_date, 1.month) }
  scope :top, -> (limit = 10) { order(points: :desc).limit(limit) }
  scope :of_team, -> (team_id) { where(team_id: team_id) }

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
        team_id: team.id,
        user_name: TeamMember.find(event.data.fetch(:recipient_id)).slack_user_name,
        date: event.valid_at.in_time_zone(team.time_zone).to_date
      ).lock!
      record.increment!(:points)
    end
  end
end
