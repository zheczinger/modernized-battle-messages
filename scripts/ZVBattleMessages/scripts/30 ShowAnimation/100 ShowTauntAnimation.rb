module Battle
  class Visual
    module ZVBattleMsgVisual
      # Show popup animation for a battler receiving Taunt's effect.
      # @param target [PFM::PokemonBattler]
      def zv_show_taunt_infliction(target)
        target_sprite = battler_sprite(target.bank, target.position)
        taunted = ZVBattleMsg::PopupMessage.new(:replace_taunt, viewport, target_sprite)
        zv_show_popup(taunted)
      end
    end
    prepend ZVBattleMsgVisual
  end

  class Move
    class Taunt
      module ZVBattleMsgMoveTaunt
        # [psdk-override]
        def parse_text_with_pokemon(csv_id, text_id, *_args, **_kwargs)
          message = super
          return message unless Configs.zv_battle_msg.replace_taunt[:enable]
          return message unless csv_id == 19 && text_id == 568

          ZVBattleMsg.tag_as_quiet_message(message)
          return message
        end
      end
      prepend ZVBattleMsgMoveTaunt
    end
  end

  module Effects
    class Taunt
      module ZVBattleMsgEffectsTaunt
        # [zv-override]
        # Function called when the effect has been added to the effects handler
        def zv_on_add
          super
          return unless Configs.zv_battle_msg.replace_taunt[:enable]

          logic.scene.visual.zv_show_taunt_infliction(@pokemon)
        end
      end
      prepend ZVBattleMsgEffectsTaunt
    end
  end
end
