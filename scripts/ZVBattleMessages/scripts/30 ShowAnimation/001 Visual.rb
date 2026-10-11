module Battle
  class Visual
    module ZVBattleMsgVisual
      # @param popup
      def zv_show_popup(popup)
        ya = Yuki::Animation
        animation = ya.player(popup.create_animation, ya.dispose_sprite(popup))
        @animations << animation
        anim.start
        wait_for_animation
      end
    end
    prepend ZVBattleMsgVisual
  end
end
