module Battle
  class Visual
    module ZVBattleMsgVisual
      # @param target [PFM::PokemonBattler]
      # @param status [Symbol]
      def zv_show_status_infliction(target, status)
        target_sprite = battler_sprite(target.bank, target.position)
        popup = ZVBattleMsg::StatusPopupMessage.new(status, viewport, target_sprite)
        zv_show_popup(popup)
      end

      # @oaran target [PFM::PokemonBattler]
      def zv_show_confusion_infliction(target)
        target_sprite = battler_sprite(target.bank, target.position)
        popup = ZVBattleMsg::PopupMessage.new(status, viewport, target_sprite)
        zv_show_popup(popup)
      end
    end
    prepend ZVBattleMsgVisual
  end

  class Logic
    class StatusChangeHandler
      module ZVBattleMsgStatusChangeHandler
        # [psdk-override]
        def parse_text_with_pokemon(csv_id, text_id, target, *_args, **_kwargs)
          message = super
          return message unless Configs.zv_battle_msg.replace_status[:enable]

          status = STATUS_APPLY_MESSAGE.invert[text_id]
          return message unless status && csv_id == 19
          return message if status == :flinch

          methods = %i[
            zv_intercept_message_confusion
            zv_intercept_message_status
          ]

          methods.each { |m| break if send(m, status, target, message) }
          return message
        end

        def zv_intercept_message_confusion(status, target, message)
          return false unless status == :confusion
          return false unless Configs.zv_battle_msg.replace_confusion[:enable]

          scene.visual.zv_show_confusion_infliction(target)
          ZVBattleMsg.tag_as_quiet_message(message)
          return true
        end

        def zv_intercept_message_status(status, target, message)
          return false unless status != :confusion && STATUS_APPLY_MESSAGE.key?(status)
          return false unless Configs.zv_battle_msg.replace_status[:enable]

          scene.visual.zv_show_status_infliction(target)
          ZVBattleMsg.tag_as_quiet_message(message)
          return true
        end
      end
      prepend ZVBattleMsgStatusChangeHandler
    end
  end
end
