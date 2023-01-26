Upvote
  .order(:created_at)
  .find_each do |upvote|
    begin
      Rails.configuration.event_store.append(
        UpvoteReceivedV2.new(
          data: {
            recipient_id: upvote.recipient_id,
            sender_id: upvote.sender_id,
            team_id: upvote.sender.team_id
          },
          metadata: {
            valid_at: upvote.created_at
          }
        ),
        stream_name: "Upvote$#{upvote.id}",
        expected_version: :none
      )
      print "."
    rescue RubyEventStore::WrongExpectedEventVersion
      puts "Upvote #{upvote.id} already has a corresponding event"
    end
  end
