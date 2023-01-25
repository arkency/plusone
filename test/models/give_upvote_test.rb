require "test_helper"

class GiveUpvoteTest < ActiveSupport::TestCase
  cover GiveUpvote

  test "pluses someone with valid params" do
    result = GiveUpvote.new.call(
      sender_user_name,
      text_message,
      trigger_word,
      team
    )

    assert_equal [receiver, sender], result
    assert_equal <<~RESULT.strip, stats.received_upvotes
      1: #{receiver_user_name}
      0: #{sender_user_name}
    RESULT
  end

  test "raises exception when try to plus one yourself" do
    assert_raises GiveUpvote::CannotUpvoteYourself do
      GiveUpvote.new.call(
        receiver_user_name,
        text_message,
        trigger_word,
        team
      )
    end

    assert_equal "", stats.received_upvotes
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
