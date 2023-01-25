require "test_helper"

class GiveUpvoteTest < ActiveSupport::TestCase
  cover GiveUpvote

  test "pluses someone with valid params" do
    GiveUpvote.new.call(
      user_name,
      text_message,
      trigger_word,
      team
    )

    assert_equal <<~RESULT.strip, stats.received_upvotes
      1: user_name2
      0: user_name1
    RESULT
  end

  test "raises exception when try to plus one yourself" do
    assert_raises GiveUpvote::CannotUpvoteYourself do
      GiveUpvote.new.call(
        user_name_same_as_receiver,
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

  def text_message
    "+1 user_name2"
  end

  def trigger_word
    "+1"
  end

  def user_name
    "user_name1"
  end

  def user_name_same_as_receiver
    "user_name2"
  end

  def user_id
    "user_id1"
  end
end
