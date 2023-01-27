# frozen_string_literal: true

require "parslet"
class SlackAliasMessageParser
  class Parser < Parslet::Parser

    private attr_reader :trigger_word
    def initialize(trigger_word)
      @trigger_word = trigger_word
    end

    rule(:space) { match["\s"].repeat(1) }
    rule(:space?) { space.maybe }

    rule(:trigger) { string(trigger_word).as(:trigger) }
    rule(:alias_keyword) { string("!alias").as(:alias_keyword) }
    rule(:username) { regex("\\w").as(:username) }
    rule(:user_alias) {  regex("[<@U[0-9a-zA-Z]*>]").as(:user_alias) }

    rule(:expected_sentence) { trigger >> space? >> alias_keyword >> space? >> username >> space? >> user_alias.maybe >> space? }
    root(:expected_sentence)

    private

    def string(trigger_word)
      str(trigger_word).as(:string)
    end

    def regex(regex)
      match[regex].repeat(1).as(:regex)
    end
  end

  class Transformer < Parslet::Transform
    rule(:string => simple(:x)) { x.to_s }
    rule(:regex => simple(:x)) { x.to_s }
  end

  def self.parse(text, trigger_word)
    Transformer.new.apply(Parser.new(trigger_word).parse(text))
  end
end