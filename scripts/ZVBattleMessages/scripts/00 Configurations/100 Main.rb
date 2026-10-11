module Configs
  module Project
    class ZVBattleMsg
      # ID of this plugin's CSV file.
      # @return [Integer]
      attr_accessor :csv_id

      # Custom identifier (prefix) to tell the plugin to use your own graphics and SFX instead of this plugin's.
      # @return [String]
      attr_accessor :prefix

      # Custom animation settings for type effectiveness hits.
      # @return [Hash]
      attr_accessor :replace_effectiveness

      # Popup settings for a move not affecting a target.
      # @return [Hash]
      attr_accessor :replace_unaffected

      # Popup settings for a missed move.
      # @return [Hash]
      attr_accessor :replace_miss

      # Popup settings for a critical hit.
      # @return [Hash]
      attr_accessor :replace_critical_hit

      # Popup settings for stat stage changes.
      # @return [Hash]
      attr_accessor :replace_stat_change

      # Popup for a move being used or failing.
      attr_accessor :replace_move_usage

      # Floating damage number settings for battlers losing or restoring health.
      # @return [Hash]
      attr_accessor :show_damage_numbers

      # Popup settings for a battler being confused.
      # @return [Hash]
      attr_accessor :replace_confusion

      # Custom animation settings for perish counts.
      # @return [Hash]
      attr_accessor :replace_perish

      # Custom animation settings for Aqua Ring procs.
      # @return [Hash]
      attr_accessor :replace_aqua_ring

      # Settings for silencing specific battle dialogue messages.
      # @param settings [Hash]
      attr_accessor :silence_messages
    end
  end

  # @!method self.zv_battle_msg
  # @return [Configs::Project::ZVBattleMsg]
  register(:zv_battle_msg, File.join('plugins', 'zv_battle_msg_config'), :yml, false, Project::ZVBattleMsg)
end
