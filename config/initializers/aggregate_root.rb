AggregateRoot.configure do |config|
  config.default_event_store = RailsEventStore::Client.new.tap do |es|
  end
end
