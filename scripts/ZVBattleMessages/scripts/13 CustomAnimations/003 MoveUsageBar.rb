module ZVBattleMsg
  class UsageBar < UI::SpriteStack
    include Offsets3D
    include HideShow

    # @param viewport [Viewport]
    def initialize(viewport)
      super(viewport, default_cache: :interface)
      create_background
      create_icon
      create_text
    end

    # @param move [Battle::Move]
    def data=(move)
      super(move.user)
      @user_name = user_name(move)
      @action_name = move.name
    end

    # Update the animations
    def update
      @animation_handler.update
    end

    # Tell if the animations are done
    # @return [Boolean]
    def done?
      return @animation_handler.done?
    end

    private

    def create_animation
      @animation_handler = Yuki::Animation::Handler.new
    end

    def create_background
      @background = add_sprite(0, 0, NO_INITIAL_IMAGE, type: Background)
    end

    def create_icon
      return unless config.user_icon.display

      add_sprite(*icon_position, NO_INITIAL_IMAGE, false, type: icon_class)
    end

    def create_text
      dimensions = [0, nil]

      if config.move_name.display
        with_font(user_font_id) do
          add_text(*user_position, *dimensions, :user_name, color: user_color_id, type: SymText)
        end
      end

      with_font(action_font_id) do
        add_text(*action_position, *dimensions, :action_name, color: action_color_id, type: SymText)
      end
    end

    class Background < Sprite
      # @param pokemon [PFM::PokemonBattler]
      def data=(user)
        return unless (self.visible = user)

        set_bitmap(background_filename(user), :interface)
      end

      # @param user [PFM::PokemonBattler]
      # @return [String]
      def background_filename(user)
        config = Configs.zv_battle_msg
        return config.interface_path('usage_bar_enemy') if user.bank != 0
        return config.interface_path('usage_bar_player') if user.from_party?

        return config.interface_path('usage_bar_ally')
      end
    end

    def config          = Configs.zv_battle_msg.replace_move_usage
    def icon_position   = config.user_icon.relative_position
    def user_font_id    = config.user_name.font_id
    def user_color_id   = config.user_name.color_id
    def user_position   = config.user_name.relative_position
    def action_font_id  = config.action_name.font_id
    def action_color_id = config.action_name.color_id
    def action_position = config.action_name.relative_position

    def icon_class = Sprite
    def user_name(action) = nil
  end

  class MoveUsageBar < UsageBar
    def icon_class = PokemonIconSprite
    def user_name(action) = action.user.given_name
  end

  class ItemUsageBar < UsageBar
    def icon_class =
  end
end
