module Battle
  class Visual
    module ZVBattleMsgVisual
      private

      # [psdk-override]
      def create_hp_animation_handler(target, hp, effectiveness, *_args, **_kwargs)
        critical_hit = @scene.logic.zv_temp_state.critical_hits.last&.shift
        handler = super

        config = Configs.zv_battle_msg
        replace_effectiveness = config.replace_effectiveness.enable
        replace_critical_hit  = config.replace_critical_hit.enable
        add_damage_numbers    = config.damage_numbers.enable
        return handler unless replace_effectiveness || replace_critical_hit || add_damage_numbers

        target_sprite = battler_sprite(target.bank, target.position)

        if replace_effectiveness && effectiveness != 1
          animation = ZVBattleMsg::EffectivenessAnimation.new(viewport, target_sprite, effectiveness)
          handler[:zv_effectiveness] = ya.player(animation.create_animation, ya.dispose_sprite(animation))
        end

        if replace_critical_hit && !add_damage_numbers && critical_hit
          animation = ZVBattleMsg::CriticalHitAnimation.new(viewport, target_sprite)
          handler[:zv_critical_hit] = ya.player(animation.create_animation, ya.dispose_sprite(animation))
        end

        if add_damage_numbers
          animation = ZVBattleMsg::DamageNumbers.new(viewport, @scene, target, hp, critical: critical_hit)
          handler[:zv_damage_numbers] = ya.player(animation.create_animation, ya.dispose_sprite(animation))
        end

        return handler
      end
    end
    prepend ZVBattleMsgVisual
  end
end
