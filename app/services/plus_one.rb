class PlusOne
  class CannotPlusOneYourself < StandardError
  end

  def call(user_name, text, trigger_word, team_id, team_domain)
    ActiveRecord::Base.transaction do
      Team.find_or_create_by(
        slack_team_id: team_id,
        slack_team_domain: team_domain
      )
      RegisterTeamMember.new.call(team_id, user_name)

      sender = PrepareSender.new.call(team_id, user_name)
      recipient =
        PrepareRecipient.new(SlackAdapter.new).call(team_id, text, trigger_word)

      recipient.receive_upvote(sender)

      SlackMessages.slack_output_message(recipient, sender)
    end
  end
end
