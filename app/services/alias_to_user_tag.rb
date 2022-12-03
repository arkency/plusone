class AliasNotAUserTag < StandardError
end
class AliasAlreadyExists < StandardError
end

class AliasToUserTag
  def call(username, aliass)
    raise AliasNotAUserTag if not_usertag?(aliass)
    raise AliasAlreadyExists if Alias.exists?(user_alias: aliass)
    Alias.create(username: username, user_alias: aliass)
  end

  private

  def not_usertag?(aliass)
    not aliass.start_with?("<@")
  end
end
