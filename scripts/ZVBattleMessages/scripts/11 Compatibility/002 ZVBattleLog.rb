module Battle
  class Scene
    # zhec's Battle Log
    # https://github.com/zheczinger/psdk-battle-log
    module ZVBattleMsgZVBattleLog
      def zv_log_message(...) = nil unless
        Scene.method_defined?(:zv_log_message, true) ||
        Scene.private_method_defined?(:zv_log_message, true)

      private

      def zv_display_message_logged?(...) = false unless
        Scene.method_defined?(:zv_display_message_logged?, true) ||
        Scene.private_method_defined?(:zv_display_message_logged?, true)
    end
    prepend ZVBattleMsgZVBattleLog
  end
end
