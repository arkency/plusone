# frozen_string_literal: true

require "parslet"
class Richtig
  class RichtigParser < Parslet::Parser

    private attr_reader :trigger_word
    def initialize(trigger_word)
      @trigger_word = trigger_word
    end

    rule(:space) { match["\s"].repeat(1) }
    rule(:space?) { space.maybe }

    rule(:trigger) { str(trigger_word).as(:trigger) }
    rule(:alias_keyword) { str("!alias").as(:alias_keyword) }
    rule(:username) { match["\\w"].repeat(1).as(:username) }
    rule(:user_alias) {  match("[<@U[0-9a-zA-Z]*>]").repeat(1).as(:user_alias) }
    rule(:expected_sentence) { trigger >> space? >> alias_keyword >> space? >> username >> space? >> user_alias >> space? }

    root(:expected_sentence)
  end

  class RichtigTransformer < Parslet::Transform
    rule(trigger: simple(:trigger)) { { :trigger => trigger } }
    rule(alias_keyword: simple(:alias_keyword)) { { :alias_keyword => alias_keyword } }
    rule(username: simple(:username)) { { :username => username } }
    rule(user_alias: simple(:user_alias)) { { :user_alias => user_alias } }
  end

  def self.parse(text, trigger_word)
    parser = RichtigParser.new(trigger_word)
    transformer = RichtigTransformer.new
    transformer.apply(parser.parse(text))
  end
end