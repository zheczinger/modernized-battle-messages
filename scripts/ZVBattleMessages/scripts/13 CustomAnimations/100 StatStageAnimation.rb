module ZVBattleMsg
  # Popup message for a stat stage change
  class StatStagePopup < PopupMessage
    STAT_TEXT_IDS = { atk: 0, dfe: 1, spd: 2, ats: 3, dfs: 4, acc: 5, eva: 6 }
    STAT_TEXT_ICONS = {
      atk: "stat_change_attack",
      dfe: "stat_change_defense",
      spd: "stat_change_speed",
      ats: "stat_change_spattack",
      dfs: "stat_change_spdefense",
      acc: "stat_change_accuracy",
      eva: "stat_change_evasion"
    }

    # @param viewport [Viewport]
    # @param target_sprite [BattleUI::PokemonSprite]
    # @param stat [Symbol]
    # @param stages [Integer]
    def initialize(viewport, target_sprite, stat, stages)
      super(nil, viewport, target_sprite)
      up = stat_up?(stages)

      create_background(up ? stat_up_background_filename : stat_down_background_filename)
      create_icon(STAT_TEXT_ICONS[stat])
      create_icon(up ? stat_up_icon_filename : stat_down_icon_filename)
      create_text(message(stat, stages))
      initialize_animation(up ? stat_up_animation_symbol : stat_down_animation_symbol, target_sprite)
    end

    private

    # Message to display on the popup
    # @param stat [Symbol]
    # @param stages [Integer]
    # @return [String, nil]
    def message(stat, stages)
      msg = parse_text(Configs.zv_battle_msg.csv_id, STAT_TEXT_IDS[stat])
      msg += ' '
      msg += '+' if stat_up?(stages)
      msg += stages.to_s
      return msg
    end

    # Is a stat being increased?
    # @param stages [Integer]
    # @return [Boolean]
    def stat_up?(stages)
      return @stages >= 0
    end

    def stat_up_animation_symbol = :rise
    def stat_up_background_filename = 'stat_up'
    def stat_up_icon_filename = 'stat_up'

    def stat_down_animation_symbol = :fall
    def stat_down_background_filename = 'stat_down'
    def stat_down_icon_filename = 'stat_down'
  end
end
