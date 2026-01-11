module Battle
  class Scene
    module ZVBattleMsgDisplayMessage
      def display_message(message, *args, **_kwargs, &_block)
        has_choices = args.size > 1
        return super if has_choices || !message.is_a?(ZVBattleMsg::SilentSceneMessage)

        zv_log_message(message) unless zv_display_message_logged?
        return nil
      end
    end
    prepend ZVBattleMsgDisplayMessage
  end
end
