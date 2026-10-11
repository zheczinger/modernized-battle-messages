module Configs
  module Project
    class ZVBattleMsg
      # Silence a battle scene message if applicable depending on settings.
      # @param message [String]
      # @param csv_id [Integer] CSV ID of the message
      # @param text_id [Integer] Text ID of the message
      def apply_silence_settings(message, csv_id, text_id)
        return unless should_tag_as_quiet_message?(csv_id, text_id)

        ::ZVBattleMsg.tag_as_quiet_message(message)
      end

      private

      # Check if a battle scene message should be silenced.
      # @param csv_id [Integer] CSV ID of the battle scene message
      # @param text_id [Integer] Text ID of the battle scene message
      # @return [Boolean]
      def should_tag_as_quiet_message?(csv_id, text_id)
        return false unless $scene.is_a?(Battle::Scene)
        return false unless @silence_messages[:enable]

        return @silence_messages[:messages].any? do |m|
          next m[:csv_id] == csv_id && m[:text_id] == text_id
        end
      end
    end
  end
end
