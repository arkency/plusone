# frozen_string_literal: true

require "parslet"

class RichtigParser < Parslet::Parser
  rule(:space) { match["\s"].repeat(1) }
  rule(:space?) { space.maybe }

  rule(:plus_one) { str("+1").as(:plus_one) }
  rule(:alias_keyword) { str("!alias").as(:alias_keyword) }
  rule(:username) { match["\\w"].repeat(1).as(:username) }
  rule(:user_alias) { str("@johndoe").as(:user_alias) }

  rule(:expected_sentence) { plus_one >> space? >> alias_keyword >> space? >> username >> space? >> user_alias }

  root(:expected_sentence)
end

class RichtigTransformer < Parslet::Transform
  rule(plus_one: simple(:plus_one)) { { :plus_one => plus_one } }
  rule(alias_keyword: simple(:alias_keyword)) { { :alias_keyword => alias_keyword } }
  rule(username: simple(:username)) { { :username => username } }
  rule(user_alias: simple(:user_alias)) { { :user_alias => user_alias } }
end

class Richtig
  def self.parse(text)
    parser = RichtigParser.new
    transformer = RichtigTransformer.new
    transformer.apply(parser.parse(text))
  end
end