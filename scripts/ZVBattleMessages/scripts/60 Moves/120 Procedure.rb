module Battle
  class Move
    module ZVBattleMsgMove
      # [psdk-override]
      def efficent_message(...)
        return super unless Configs.zv_battle_msg.replace_effectiveness[:enable]

        logic.zv_temp_state.with_attributes(quiet_messages: true) { super }
      end

      # [psdk-override]
      def hit_criticality_message(...)
        return super unless Configs.zv_battle_msg.replace_critical_hit[:enable]

        logic.zv_temp_state.with_attributes(quiet_messages: true) { super }
      end

      # [psdk-override]
      def parse_text_with_pokemon(csv_id, text_id, target, *args, **_kwargs)
        message = super
        methods = %i[
          zv_intercept_message_miss
          zv_intercept_message_unaffected
        ]

        methods.each { |m| break if send(m, csv_id, text_id, target, message) }
        return message
      end
    end
    prepend ZVBattleMsgMove
  end
end
