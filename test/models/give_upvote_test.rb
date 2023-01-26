require "test_helper"

class GiveUpvoteTest < ActiveSupport::TestCase
  cover GiveUpvote

  test "pluses someone with valid params" do
    result =
      GiveUpvote.new.call(sender_user_name, text_message, trigger_word, team)

    assert_equal [receiver, sender], result
    assert_equal <<~RESULT.strip, stats.received_upvotes
      1: #{receiver_user_name}
      0: #{sender_user_name}
    RESULT
  end

  test "raises exception when try to plus one yourself" do
    assert_raises GiveUpvote::CannotUpvoteYourself do
      GiveUpvote.new.call(receiver_user_name, text_message, trigger_word, team)
    end

    assert_equal "", stats.received_upvotes
  end

  test "upvoting publishes an event" do
    recipient, sender =
      GiveUpvote.new.call(sender_user_name, text_message, trigger_word, team)

    last_event = Rails.configuration.event_store.read.last
    assert_equal "UpvoteReceivedV2", last_event.event_type
    assert_equal recipient.id, last_event.data[:recipient_id]
    assert_equal sender.id, last_event.data[:sender_id]
    assert_equal team.id, last_event.data[:team_id]
  end

  test "no duplicate events from upvotes" do
    GiveUpvote.new.call(sender_user_name, text_message, trigger_word, team)
    upvote = Upvote.last

    assert_raises RubyEventStore::WrongExpectedEventVersion do
      Rails.configuration.event_store.append(
        UpvoteReceivedV2.new,
        stream_name: "Upvote$#{upvote.id}",
        expected_version: :none
      )
    end
  end

  test "upcasting from previus event version" do
    recipient, sender =
      GiveUpvote.new.call(sender_user_name, text_message, trigger_word, team)

    Rails.configuration.event_store.append(
      UpvoteReceived.new(
        event_id: event_id = SecureRandom.uuid,
        data: {
          recipient_id: recipient.id,
          sender_id: sender.id
        }
      )
    )
    last_event = Rails.configuration.event_store.read.last
    assert_equal "UpvoteReceivedV2", last_event.event_type
    assert_equal team.id, last_event.data[:team_id]
    assert_equal event_id, last_event.event_id
  end

  private

  def stats
    Stats.new(team.id)
  end

  def team
    Team.register("external_id", "kakadudu")
  end

  def sender
    team.register_member(sender_user_name)
  end

  def receiver
    team.register_member(receiver_user_name)
  end

  def text_message
    "+1 #{receiver_user_name}"
  end

  def trigger_word
    "+1"
  end

  def sender_user_name
    "user_name1"
  end

  def receiver_user_name
    "user_name2"
  end
end
