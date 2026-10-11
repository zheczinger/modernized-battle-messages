module ZVBattleMsg
  class PopupAnimation
    # Class for making a popup message rise up.
    class RiseAnimation < PopupAnimation
      # Create the animation
      # @return [Yuki::Animation::AnimationMixin]
      def create_animation
        ya = Yuki::Animation

        return ya.parallel(
          ya.move_discreet(duration, @popup, x, start_y, x, end_y),
          ya.player(
            ya.opacity_change(0.1, @popup, 0, 255),
            ya.wait((duration - 0.2).clamp(0, Float::INFINITY)),
            ya.opacity_change(0.1, @popup, 255, 0)
          )
        )
      end

      private

      def x        = @target_sprite.x + x_offset
      def start_y  = @target_sprite.y + y_offset
      def end_y    = start_y + y_displacement
      def duration = 1.2
      def y_displacement = -20
    end

    register(:rise, RiseAnimation)
  end
end
