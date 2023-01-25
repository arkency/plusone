class PlusOne
  class CannotPlusOneYourself < StandardError
  end

  def call(params, team_params)
    ActiveRecord::Base.transaction do
      Team.find_or_create_by(
        slack_team_id: team_params.fetch(:team_id),
        slack_team_domain: team_params.fetch(:team_domain)
      )
      RegisterTeamMember.new.call(team_params.fetch(:team_id), params.fetch(:user_name))

      sender =
        PrepareSender.new.call(
          team_params.fetch(:team_id),
          params.fetch(:user_name)
        )
      recipient =
        PrepareRecipient.new(SlackAdapter.new).call(
          team_params.fetch(:team_id),
          params
        )

      raise CannotPlusOneYourself if sender.eql?(recipient)

      recipient.increment!(:points)
      Upvote.create(recipient: recipient, sender: sender)

      SlackMessages.slack_output_message(recipient, sender)
    end
  end
end
