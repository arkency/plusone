Rails.application.routes.draw do
  class StatsConstraint
    def matches?(request)
      MessageParser.new(
        request.request_parameters['text'],
        request.request_parameters['trigger_word']
      ).recipient_name == "!stats"
    end
  end

  class EmptyConstraint
    def matches?(request)
      MessageParser.new(
        request.request_parameters['text'],
        request.request_parameters['trigger_word']
      ).recipient_name.empty?
    end
  end

  post "/slack" => "slack#stats", constraints: StatsConstraint.new
  post "/slack" => "slack#empty", constraints: EmptyConstraint.new
  post "/slack/plus" => "slack#plus"
  post "/slack/minus" => "slack#minus"

  root "slack#index"
end
