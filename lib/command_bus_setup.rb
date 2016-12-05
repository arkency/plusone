require 'arkency/command_bus'
module CommandBusSetup
  def command_bus
    command_bus ||= Arkency::CommandBus.new.tap do |cb|
      register    = cb.method(:register)
      {
        Command::GiveUpvote => CommandHandler::GiveUpvote.new
      }.map { |ch| cb.register(*ch) }
    end
  end
end
