module Battle
  class Visual
    module ZVBattleMsgVisual
      # Show animation for a battler avoiding an attack
      # @param target [PFM::PokemonBattler]
      def zv_show_miss(target)
        miss = ZVBattleMsg::MissAnimation.new(viewport, @scene, target)
        zv_show_popup(miss)
      end
    end
    prepend ZVBattleMsgVisual
  end

  class Move
    module ZVBattleMsgMove
      def zv_intercept_message_miss(csv_id, text_id, target, message)
        return false unless Configs.zv_battle_msg.replace_miss[:enable]
        return false unless csv_id == 19 && text_id == 213

        scene.visual.zv_show_miss(target)
        ZVBattleMsg.tag_as_quiet_message(message)
        return true
      end
    end
    prepend ZVBattleMsgMove
  end
end
