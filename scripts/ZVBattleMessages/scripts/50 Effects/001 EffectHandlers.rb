module Battle
  module Effects
    class EffectsHandler
      module ZVBattleMsgEffectsHandler
        # [psdk-override]
        def add(...)
          super
          effect.zv_on_add
        end
      end
      prepend ZVBattleMsgEffectsHandler
    end
  end
end
