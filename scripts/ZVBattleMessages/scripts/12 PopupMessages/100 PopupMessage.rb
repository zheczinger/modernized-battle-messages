module ZVBattleMsg
  # Base class for creating a popup message animation for a battler.
  class PopupMessage < UI::SpriteStack
    include Offsets3D

    # @param db_symbol [Symbol]
    # @param viewport [Viewport]
    # @param target_sprite [BattleUI::PokemonSprite]
    def initialize(db_symbol, viewport, target_sprite)
      super(viewport, default_cache: :animation)
      self.opacity = 0

      common_settings = Configs.zv_battle_msg.common
      db_settings = Configs.zv_battle_msg.send(db_symbol)

      @icon_filename = db_settings[:icon] || common_settings[:icon]
      @background_filename = db_settings[:background] || common_settings[:background]
      @animation_symbol = db_settings[:animation] || common_settings[:animation]
      @font_id = db_settings[:font_id] || common_settings[:font_id]
      @text_color = db_settings[:text_color] || common_settings[:text_color]
      @text_id = db_settings[:text_id]

      create_background
      create_icon
      create_text
      initialize_animation(target_sprite)
    end

    # Create the animation for the popup message
    # @return [Yuki::Animation::AnimationMixin]
    def create_animation
      ya = Yuki::Animation
      return ya.player(@animation.create_animation, ya.dispose_sprite(self))
    end

    private

    # Create the popup message's background sprite
    def create_background
      filename = Configs.zv_battle_msg.animation_path('backgrounds', @background_filename)
      return unless RPG::Cache.animation_exist?(filename)

      sprite = add_background(filename)
      sprite.set_origin(sprite.width / 2, sprite.height)
    end

    # Create the popup message's icon sprite
    def create_icon
      filename = Configs.zv_battle_msg.animation_path('icons', @icon_filename)
      sprite = add_sprite(*icon_position, filename)
      sprite.set_origin(sprite.width / 2, sprite.height)
    end

    # Draw the popup message's text
    def create_text
      message = parse_text(Configs.zv_battle_msg.csv_id, @text_id)
      with_font(@font_id) { add_text(*text_position, *text_dimensions, message, color: @color_id) }
    end

    # Initialize the popup message's animation
    # @param target_sprite [BattleUI::PokemonSprite]
    def initialize_animation(target_sprite)
      @animation = PopupAnimation.new(@animation_symbol, self, target_sprite)
    end

    def icon_position   = [6, 0]
    def text_position   = [26, -13]
    def text_dimensions = [96, 13]
  end
end
