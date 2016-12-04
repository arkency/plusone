module Command
  module Execute
    def execute(command, **args)
      command.validate!
      handler_for(command).new.call(command)
    end

    private
    def handler_for(command)
      {
        Command::GiveUpvote          => CommandHandlers::GiveUpvote,
      }.fetch(command.class)
    end
  end
end
