module ZVBattleMsg
  # Handle animation where a move misses its target
  class EffectivenessAnimation < UI::SpriteStack
    include Offsets3D

    # @param viewport [Viewport]
    # @param target_sprite [BattleUI::PokemonSprite]
    # @param effectiveness [Float]
    def initialize(viewport, target_sprite, effectiveness)
      super(viewport, default_cache: :animation)
      @target_sprite = target_sprite

      self.z = @target_sprite.z
      self.opacity = 0
      create_text(effectiveness)
    end

    # Create the animation
    # @return [Yuki::Animation::AnimationMixin]
    def create_animation
      ya = Yuki::Animation
      tx = @target_sprite.x
      ty = @target_sprite.y

      return ya.player(
        ya.send_command_to(self, :opacity=, 255),
        ya.move_discreet(move_duration, self, tx, ty, tx, ty + y_displacement),
        ya.wait(wait_duration),
        ya.send_command_to(self, :opacity=, 0),
        ya.dispose_sprite(self)
      )
    end

    private

    # Draw text for the popup message
    # @param effectiveness [Float]
    def create_text(effectiveness)
      if hyper_effective?(effectiveness)
        getter = :hyper_effective
      elsif barely_effective?(effectiveness)
        getter = :barely_effective
      elsif super_effective?(effectiveness)
        getter = :super_effective
      elsif not_very_effective?(effectiveness)
        getter = :not_very_effective
      end

      return unless getter

      section = Configs.zv_battle_msg.replace_effectiveness.get(getter)
      msg = parse_text(Configs.zv_battle_msg.csv_id, section.text_id)

      with_font(section.font_id) do
        add_text(0, 0, width, _height = nil, msg, alignment, outline_size, color: section.color_id)
      end
    end

    # Is this hyper effective?
    # @param effectiveness [Float]
    # @return [Boolean]
    def hyper_effective?(effectiveness)
      show_hyper = Configs.zv_battle_msg.replace_effectiveness.show_hyper
      return effectiveness > 2 && show_hyper
    end

    # Is this at least super effective?
    # @param effectiveness [Float]
    # @return [Boolean]
    def super_effective?(effectiveness)
      return effectiveness > 1
    end

    # Is this at most not very effective?
    # @param effectiveness [Float]
    # @return [Boolean]
    def not_very_effective?(effectiveness)
      return effectiveness > 0 && effectiveness < 1
    end

    # Is this barely effective?
    # @param effectiveness [Float]
    # @return [Boolean]
    def barely_effective?(effectiveness)
      show_hyper = Configs.zv_battle_msg.replace_effectiveness.show_hyper
      return effectiveness > 0 && effectiveness < 0.5 && show_hyper
    end

    # Offsets for the popup message relative to a battler's sprite
    # @return [Array<Array<Integer>>] Player and enemy offsets in that order
    def position_offsets = [[0, -42], [0, -42]]

    def width = 96
    def alignment = 0
    def outline_size = 2
    def move_duration = 0.3
    def wait_duration = 0.65
    def y_displacement = -20
  end
end
