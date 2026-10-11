module Battle
  class Logic
    class DamageHandler
      module ZVBattleMsgDamageHandler
        # [psdk-override]
        def damage_change(*args, **_kwargs, &_block)
          skill = args[3]

          @logic.zv_temp_state.with_pushed_attributes(
            critical_hits: [skill&.critical_hit?]
          ) { super }
        end

        # [psdk-override]
        def drain(*args, **_kwargs, &_block)
          skill = args[3]

          @logic.zv_temp_state.with_pushed_attributes(
            critical_hits: [skill&.critical_hit?]
          ) { super }
        end

        # [psdk-override]
        def heal_change(...)
          @logic.zv_temp_state.with_pushed_attributes(
            critical_hits: []
          ) { super }
        end
      end
      prepend ZVBattleMsgDamageHandler
    end
  end
end
