# zhec's Battle Log
# https://github.com/zheczinger/battle-log
module Battle
  class Scene
    module ZVBattleMsgSupportingZVBattleLog
      def zv_log_message(...) = nil unless method_defined?(:zv_log_message)
      def zv_display_message_logged? = false unless method_defined?(:zv_display_message_logged?)
    end
    prepend ZVBattleMsgSupportingZVBattleLog
  end
end
