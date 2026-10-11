module ZVBattleMsg
  class PopupAnimation
    # Class for making a popup message fall down.
    class FallAnimation < RiseAnimation
      private

      def start_y = method(:end_y).super_method.call
      def end_y = method(:start_y).super_method.call
    end

    register(:fall, FallAnimation)
  end
end
