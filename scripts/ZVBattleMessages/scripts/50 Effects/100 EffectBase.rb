module Battle
  module Effects
    class EffectBase
      module ZVBattleMsgEffectBase
        def zv_on_add = nil
      end
      prepend ZVBattleMsgEffectBase
    end
  end
end
