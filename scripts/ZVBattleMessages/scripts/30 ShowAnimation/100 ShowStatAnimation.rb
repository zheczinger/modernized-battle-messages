module BattleUI
  class PokemonSprite
    module ZVBattleMsgPokemonSprite
      # [psdk-override]
      def change_stat_animation(amount, *_args, **_kwargs)
        super
        return unless unless Configs.zv_battle_msg.replace_stat_change[:enable]

        # ZVBattleMsg::StatStagePopup must be instantiated after UI::StatAnimation (which is
        # instantiated in super) to ensure that the stat animation particles go behind the popup.
        stat = @scene.logic.zv_temp_state.stat_changes.last
        popup = ZVBattleMsg::StatPopupMessage.new(viewport, self, stat, amount)

        ya = Yuki::Animation
        animation = ya.player(popup.create_animation, ya.dispose_sprite(popup))
        animation_handler[:zv_stat_change] = animation.start
      end
    end
    prepend ZVBattleMsgPokemonSprite
  end
end

module Battle
  class Visual
    module ZVBattleMsgVisual
      # [psdk-override]
      def show_stat_animation(target, amount, *_args, **_kwargs)
        return super unless Configs.zv_battle_msg.replace_stat_change[:enable]

        # Show the stat animation even when the target is out of reach
        wait_for_animation
        target_sprite = battler_sprite(target.bank, target.position)
        target_sprite.change_stat_animation(amount)
        wait_for_animation
      end
    end
    prepend ZVBattleMsgVisual
  end

  class Logic
    class StatChangeHandler
      module ZVBattleMsgStatChangeHandler
        # [psdk-override]
        def show_stat_change_text_and_animation(stat, *_args, **_kwargs)
          return super unless Configs.zv_battle_msg.replace_stat_change[:enable]

          @logic.zv_temp_state.with_pushed_attributes(stat_changes: stat) do
            @logic.zv_temp_state.with_attributes(quiet_messages: true) { super }
          end
        end
      end
      prepend ZVBattleMsgStatChangeHandler
    end
  end
end
