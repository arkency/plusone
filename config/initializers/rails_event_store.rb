require "aggregate_root"

Rails.configuration.to_prepare do
  Rails.configuration.event_store = EventStore.new
  Rails.configuration.command_bus = CommandBus.new

  Rails.configuration.event_store.tap do |store|
    store.subscribe_to_all_events(RailsEventStore::LinkByEventType.new)
    store.subscribe_to_all_events(RailsEventStore::LinkByCorrelationId.new)
    store.subscribe_to_all_events(RailsEventStore::LinkByCausationId.new)
  end
end
