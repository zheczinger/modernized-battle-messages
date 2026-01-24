module Battle
  class Visual
    module ZVBattleMsgShowHP
      private

      def create_hp_animation_handler(target, hp, effectiveness, *_args, **_kwargs)
        critical_hit = @scene.logic.zv_battle_msg_internal.critical_hits.last&.shift
        config = Configs.zv_battle_msg
        handler = super

        return handler unless
          config.replace_effectiveness ||
          config.replace_critical_hit ||
          config.damage_numbers.enable

        batch = ZVBattleMsg::HPRelatedBatchAnimation.new(@scene)
        handler[:zv_popups] = batch.create_animation(
          target, hp, effectiveness: effectiveness, critical: critical_hit
        )

        return handler
      end
    end
    prepend ZVBattleMsgShowHP
  end
end
