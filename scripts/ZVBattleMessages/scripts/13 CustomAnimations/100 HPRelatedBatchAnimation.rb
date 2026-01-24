module ZVBattleMsg
  # Responsible for creating an animation for all popup messages related to an HP animation
  class HPRelatedBatchAnimation
    # param scene [Battle::Scene]
    def initialize(scene)
      @scene = scene
    end

    # @param target [PFM::PokemonBattler]
    # @param hp [Integer]
    # @param effectiveness [Float, nil]
    # @param critical [Boolean, nil]
    # @return [Yuki::Animation::AnimationMixin]
    def create_animation(target, hp, effectiveness:, critical:)
      ya = Yuki::Animation
      hit_popups = hit_related_popups(target, effectiveness: effectiveness, critical: critical)

      anims = hit_popups.map.with_index do |popup, index|
        next ya.player(
          ya.wait(time_between_popups * index),
          popup.create_animation,
          ya.dispose_sprite(popup)
        )
      end

      if (dmg_popup = damage_numbers_popup(target, hp))
        anims << ya.player(
          dmg_popup.create_animation(extra_duration: extra_damage_number_time(hit_popups.size)),
          ya.dispose_sprite(dmg_popup)
        )
      end

      anims << ya.wait(0) if anims.empty?
      return ya.parallel(*anims)
    end

    private

    # @param target [PFM::PokemonBattler]
    # @param effectiveness [Float, nil]
    # @param cfitical [Boolean, nil]
    # @return [Array<ZVBattleMsg::PopupMessage>]
    def hit_related_popups(target, effectiveness:, critical:)
      target_sprite = @scene.visual.battler_sprite(target.bank, target.position)
      return [
        critical_hit_popup(target_sprite, critical),
        hit_effectiveness_popup(target_sprite, effectiveness)
      ].compact
    end

    # @param target_sprite [BattleUI::PokemonSprite]
    # @poram effectiveness [Float, nil]
    # @return [ZVBattleMsg::PopupMessage, nil]
    def hit_effectiveness_popup(target_sprite, effectiveness)
      return unless Configs.zv_battle_msg.replace_effectiveness && effectiveness

      viewport = @scene.visual.viewport
      return SuperEffectivePopup.new(viewport, @scene, target_sprite) if effectiveness > 1
      return NotVeryEffectivePopup.new(viewport, @scene, target_sprite) if effectiveness > 0 && effectiveness < 1

      return nil
    end

    # @param target_sprite [BattleUI::PokemonSprite]
    # @poram critical [Boolean, nil]
    # @return [ZVBattleMsg::PopupMessage, nil]
    def critical_hit_popup(target_sprite, critical)
      return unless Configs.zv_battle_msg.replace_critical_hit && critical

      viewport = @scene.visual.viewport
      return CriticalHitPopup.new(viewport, @scene, target_sprite)
    end

    # @param target [PFM::PokemonBattler]
    # @poram hp [Integer]
    # @return [ZVBattleMsg::DamageNumbers, nil]
    def damage_numbers_popup(target, hp)
      return unless Configs.zv_battle_msg.damage_numbers.enable

      viewport = @scene.visual.viewport
      klass = hp <= 0 ? DamageNumbers : HealNumbers
      return klass.new(viewport, @scene, target, hp.abs)
    end

    # Amount of time to wait between playing each popup message other than damage numbers
    # @return [Float]
    def time_between_popups
      return 0.6
    end

    # Additional amount of time to add to the damage numbers
    # @param num_popups [Integer] Number of other popups to play
    # @return [Float]
    def extra_damage_number_time(num_popups)
      duration = time_between_popups * (num_popups - 1) - 0.1
      return duration.clamp(0, Float::INFINITY)
    end
  end
end
