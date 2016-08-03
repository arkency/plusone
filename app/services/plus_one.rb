class PlusOne
  class CannotPlusOneYourself < StandardError; end
  class InvalidSlackToken < StandardError; end

  def initialize(team)
    @team = team
  end

  def call(params)
    ActiveRecord::Base.transaction do
      recipient_name = MessageParser.new(params[:text], params[:trigger_word]).recipient_name
      sender, recipient = prepare_transaction_actors.(params)
      raise InvalidSlackToken if recipient.slack_user_name == 'u'
      raise CannotPlusOneYourself if sender == recipient
      recipient.increment!(:points)
      {
        text: "#{sender.slack_user_name}(#{sender.points}) gave +1 for #{recipient.slack_user_name}(#{recipient.points})",
        parse: "none"
      }
    end
  end

  def prepare_transaction_actors
    PrepareTransactionActors.new(@team)
  end

end
