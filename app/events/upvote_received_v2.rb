UpvoteReceivedV2 =
  Class.new(Event) do
    def self.from_v1
      lambda do |record|
        RubyEventStore::Record.new(
          event_type: name.to_s,
          data:
            record.data.merge(
              team_id: TeamMember.find(record.data.fetch(:sender_id)).team_id
            ),
          metadata: record.metadata,
          timestamp: record.timestamp,
          valid_at: record.valid_at,
          event_id: record.event_id
        )
      end
    end
  end
