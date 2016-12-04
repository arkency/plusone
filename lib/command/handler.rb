module Command
  class Handler
    protected
    def with_aggregate(aggregate_id)
      aggregate = build(aggregate_id)
      yield aggregate
      aggregate.store(Rails.configuration.event_store_name)
    end

    private

    def build(aggregate_id)
      aggregate_class.new(aggregate_id).tap do |aggregate|
        aggregate.load(Rails.configuration.event_store_name)
      end
    end
  end
end
