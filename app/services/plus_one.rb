class PlusOne
  class CannotPlusOneYourself < StandardError; end
  class InvalidSlackToken < StandardError; end

  def initialize(team)
    @team = team
  end

  def call(params)
    ActiveRecord::Base.transaction do
      sender, recipient = prepare_transaction_actors.call(params)
      raise InvalidSlackToken if recipient.slack_user_name == 'u'
      raise CannotPlusOneYourself if sender == recipient
      recipient.increment!(:points)
      Plus.create(recipient: recipient, sender: sender, channel: params[:channel])

      return {
        text: "#{sender.slack_user_name}(#{sender.points}) gave +1 for #{recipient.slack_user_name}(#{recipient.points})",
        parse: "none"
      }
    end
  end

  private

  def prepare_transaction_actors
    PrepareTransactionActors.new(@team, SlackAdapter.new(@team.slack_token))
  end
end
