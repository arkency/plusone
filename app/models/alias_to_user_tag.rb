class AliasToUserTag
  AlreadyExists = Class.new(StandardError)

  def call(username, aliass)
    raise AlreadyExists if Alias.exists?(user_alias: aliass)
    Alias.create(username: username, user_alias: aliass)
  end
end
