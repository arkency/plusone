module CommandHandler
  class Base
    protected
    def with_aggregate(aggregate_id)
      aggregate = build(aggregate_id)
      yield aggregate
      aggregate.store(stream_name)
    end

    private

    def build(aggregate_id)
      aggregate_class.new(aggregate_id).tap do |aggregate|
        aggregate.load(stream_name)
      end
    end

    def stream_name
      'stream'
    end
  end
end
