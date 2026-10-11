module Battle
  class Scene
    module ZVBattleMsgScene
      def display_message(message, *args, **_kwargs, &_block)
        has_choices = args.size > 1
        return super if has_choices
        return super unless logic.zv_temp_state.quiet_messages || message.is_a?(ZVBattleMsg::SilentSceneMessage)

        zv_log_message(message) unless zv_display_message_logged?
        return nil
      end
    end
    prepend ZVBattleMsgScene
  end
end
