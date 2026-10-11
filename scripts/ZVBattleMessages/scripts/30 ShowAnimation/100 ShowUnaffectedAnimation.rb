module Battle
  class Visual
    module ZVBattleMsgVisual
      # Show animation of a battler being immune to a move
      # @param target [PFM::PokemonBattler]
      def zv_show_unaffected(target)
        target_sprite = battler_sprite(target.bank, target.position)
        popup = ZVBattleMsg::PopupMessage.new(:replace_unaffected, viewport, target_sprite)
        zv_show_popup(popup)
      end
    end
    prepend ZVBattleMsgVisual
  end

  class Move
    module ZVBattleMsgMove
      def zv_intercept_message_unaffected(csv_id, text_id, target, message)
        return false unless Configs.zv_battle_msg.replace_miss[:enable]
        return false unless csv_id == 19 && text_id == 210

        scene.visual.zv_show_unaffected(target)
        ZVBattleMsg.tag_as_quiet_message(message)
        return true
      end
    end
    prepend ZVBattleMsgMove
  end
end
