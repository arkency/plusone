module CommandBusSetup
  def command_bus
    command_bus ||= Arkency::CommandBus.new.tap |cb| do
      register    = cb.method(:register)
      {
      }.map(&:register)
    end
  end
end
