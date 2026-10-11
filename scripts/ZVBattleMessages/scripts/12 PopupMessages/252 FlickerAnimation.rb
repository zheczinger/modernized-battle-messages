module ZVBattleMsg
  class PopupAnimation
    # Class for making a popup message flicker on and off.
    class FlickerAnimation < PopupAnimation
      # Create the animation
      # @return [Yuki::Animation::AnimationMixin]
      def create_animation
        ya = Yuki::Animation
        fade_in  = -> { ya.opacity_change(fade_in_duration, @popup, 0, 255) }
        fade_out = -> { ya.opacity_change(fade_out_duration, @popup, 255, 0) }
        waiting  = -> { ya.wait(wait_duration) }

        tx = @target_sprite.x + x_offset
        ty = @target_sprite.y + y_offset

        return ya.player(
          ya.move_discreet(0, @popup, tx, ty, tx, ty),
          fade_in.call, waiting.call, fade_out.call,
          fade_in.call, waiting.call, fade_out.call
        )
      end

      private

      def fade_in_duration  = 0.125
      def fade_out_duration = 0.125
      def wait_duration     = 0.45
    end

    register(:flicker, FlickerAnimation)
  end
end
