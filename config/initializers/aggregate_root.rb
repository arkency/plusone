require 'rails_event_store'

AggregateRoot.configure do |config|
  config.default_event_store = RailsEventStore::Client.new.tap do |es|
    es.subscribe(Denormalizers::UpvoteGiven.new, [Events::UpvoteGiven])
  end
end
