class AliasToUserTag
  NotAUserTag = Class.new(StandardError)
  AlreadyExists = Class.new(StandardError)

  def call(username, aliass)
    raise NotAUserTag if not_usertag?(aliass)
    raise AlreadyExists if Alias.exists?(user_alias: aliass)
    Alias.create(username: username, user_alias: aliass)
  end

  private

  def not_usertag?(aliass)
    not aliass.start_with?("<@")
  end
end
