module ZVBattleMsg
  module SilentSceneMessage; end

  def self.tag_as_quiet_message(message)
    message.singleton_class.prepend(SilentSceneMessage)
  end
end
