Rails.application.routes.draw do
  mount RailsEventStore::Browser => '/res' if Rails.env.development?
  class StatsConstraint
    def matches?(request)
      MessageParser.new(
        request.request_parameters["text"],
        request.request_parameters["trigger_word"]
      ).recipient_name == "!stats"
    end
  end

  class AliasConstraint
    def matches?(request)
      MessageParser.new(
        request.request_parameters["text"],
        request.request_parameters["trigger_word"]
      ).recipient_name == "!alias"
    end
  end

  class GiversConstraint
    def matches?(request)
      MessageParser.new(
        request.request_parameters["text"],
        request.request_parameters["trigger_word"]
      ).recipient_name == "!givers"
    end
  end

  class EmptyConstraint
    def matches?(request)
      MessageParser
        .new(
          request.request_parameters["text"],
          request.request_parameters["trigger_word"]
        )
        .recipient_name
        .empty?
    end
  end

  class LeaderboardConstraint
    def matches?(request)
      MessageParser.new(
        request.request_parameters["text"],
        request.request_parameters["trigger_word"]
      ).recipient_name == "!leaderboard"
    end
  end

  post "/slack/plus" => "slack#stats", :constraints => StatsConstraint.new
  post "/slack/plus" => "slack#alias", :constraints => AliasConstraint.new
  post "/slack/plus" => "slack#givers", :constraints => GiversConstraint.new
  post "/slack/plus" => "slack#empty", :constraints => EmptyConstraint.new
  post "/slack/plus" => "slack#leaderboard", :constraints => LeaderboardConstraint.new
  post "/slack/plus" => "slack#plus"

  get "/:team_domain/leaderboards/year" => "leaderboards#show"
end
