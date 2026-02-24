module Battle
  class Visual
    module ZVBattleMsgInfoBars
      # Set the state info
      # @param state [Symbol] kind of state (:choice, :move, :move_animation)
      # @param pokemon [Array<PFM::PokemonBattler>] optional list of Pokemon to show (move)
      def set_info_state(state, pokemon = nil)
        return super
      ensure
        zv_hide_usage_bars if state == :move_animation
      end

      def zv_hide_usage_bars
        @zv_move_usage_bar.hide
        @zv_item_usage_bar.hide
      end
    end
    prepend ZVBattleMsgInfoBars
  end
end
