class AliasNotAUserTag < StandardError; end

class AliasUser

  def call(username, aliass)
    raise AliasNotAUserTag if not_usertag?(aliass)

    Alias.create(username: username, user_alias: aliass)
  end

  private

  def not_usertag?(aliass)
    not aliass.start_with?("<@")
  end
end