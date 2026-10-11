module Battle
  class Visual
    module ZVBattleMsgVisual
      # Show popup animation for a battler receiving Perish Song's effect.
      # @param target [PFM::PokemonBattler]
      def zv_show_perish_infliction_popup(target)
        target_sprite = battler_sprite(target.bank, target.position)
        perish = ZVBattleMsg::PopupMessage.new(:replace_perish, viewport, target_sprite)
        zv_show_popup(perish)
      end

      # Show popup animation for the battler's perish count going down.
      # @param target [PFM::PokemonBattler]
      # @param old_count [Integer]
      # @param new_count [Integer]
      def zv_show_perish_countdown(target, old_count, new_count)
        target_sprite = battler_sprite(target.bank, target.position)
        perish = ZVBattleMsg::PerishAnimation.new(viewport, @scene, target_sprite, old_count, new_count)
        zv_show_popup(perish)
      end
    end
    prepend ZVBattleMsgVisual
  end

  class Move
    class PerishSong
      module ZVBattleMsgMovePerishSong
        # [psdk-override]
        def parse_text(csv_id, text_id, *_args, **_kwargs)
          message = super
          return message unless Configs.zv_battle_msg.replace_perish[:enable]
          return message unless csv_id == 18 && text_id == 125

          ZVBattleMsg.tag_as_quiet_message(message)
          return message
        end
      end
      prepend ZVBattleMsgMovePerishSong
    end
  end

  module Effects
    class PerishSong
      module ZVBattleMsgEffectsPerishSong
        # [zv-override]
        # Function called when the effect has been added to the effects handler
        def zv_on_add
          super
          return unless Configs.zv_battle_msg.replace_perish[:enable]

          logic.scene.visual.zv_show_perish_infliction_popup(@pokemon)
        end

        # [psdk-override]
        def parse_text_with_pokemon(csv_id, text_id, target, *_args, **_kwargs)
          message = super
          return message unless Configs.zv_battle_msg.replace_perish[:enable]
          return message unless csv_id == 19 && text_id == 863

          scene.visual.zv_show_perish_countdown(target, @counter, @counter - 1)
          ZVBattleMsg.tag_as_quiet_message(message)
          return message
        end
      end
      prepend ZVBattleMsgEffectsPerishSong
    end
  end
end
