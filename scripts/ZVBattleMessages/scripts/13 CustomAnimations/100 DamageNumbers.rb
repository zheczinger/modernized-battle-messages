module ZVBattleMsg
  # Handle damage popup numbers animation in the battle scene
  class DamageNumbers < UI::SpriteStack
    include Offsets3D
    include MoveToTarget

    # @param viewport [Viewport]
    # @param scene [Battle::Scene]
    # @param target [PFM::PokemonBattler]
    # @param damage [Integer]
    # @param critical [Boolean]
    def initialize(viewport, scene, target, damage, critical: false)
      super(viewport, default_cache: :animation)
      @target = target
      target_sprite = scene.visual.battler_sprite(target.bank, target.position)

      self.z = target_sprite.z
      self.opacity = 0

      move_to_target(target_sprite)
      create_critical_sprite if critical
      create_text(damage)
    end

    # Create the animation
    # @return [Yuki::Animation::AnimationMixin]
    def create_animation
      ya = Yuki::Animation

      return ya.player(
        ya.parallel(number_animation, criticality_animation),
        ya.wait(wait_duration),
        ya.send_command_to(self, :opacity=, 0),
        ya.dispose_sprite(self)
      )
    end

    private

    # Create sprite for critical damage
    def create_critical_sprite
      return unless Configs.zv_battle_msg.replace_critical_hit.enable

      filename = Configs.zv_battle_msg.animation_path(critical_background_filename)
      @critical_bg = add_background(filename, type: SpriteSheet)
    end

    # Draw text for the damage value
    # @param damage_value [Integer]
    def create_text(damage_value)
      display_value = transform_to_display_value(damage_value)
      dx = calculate_left_digit_x_offset(display_value)

      @drawn_digits = display_value.each_char.map do |digit|
        text = with_font(font_id) do
          add_text(dx, 0, _width = 0, _height = nil, digit, _align = 0, outline_size, color: color_id(damage_value))
        end

        dx += text.real_width + space_after_digit
        next text
      end
    end

    # Animation for popping up the damage number
    # @return [Yuki::Animation::AnimationMixin]
    def number_animation
      ya = Yuki::Animation

      animations = @drawn_digits.map.with_index do |digit, index|
        dx = digit.x
        dy1 = digit.y
        dy2 = dy1 + y_displacement

        next ya.player(
          ya.wait(time_between_digits * index),
          ya.parallel(
            ya.send_command_to(digit, :opacity=, 255),
            ya.move_discreet(bounce_duration, digit, dx, dy1, dx, dy2, distortion: animation_distortion_type)
          )
        )
      end

      return ya.parallel(*animations)
    end

    # Animation for showing criticality in the damage numbers
    # @return [Yuki::Animation::AnimationMixin]
    def criticality_animation
      ya = Yuki::Animation
      return ya.wait(0) unless @critical_bg

      return ya.player(
        ya.send_command_to(@critical_bg, :opacity=, 255),
        ya.sprite_sheet_animation(0.1, @critical_bg, critical_sprite_cells)
      )
    end

    # Sprite cells from critical damage spritesheet to show
    # @return [Array<Array<Integer>>]
    def critical_sprite_cells = [[0, 0], [1, 0], [2, 0]]

    # Damage value to display as a string based on style
    # @param damage_value [Integer]
    # @return [String]
    def transform_to_display_value(damage_value)
      display_value = ''
      display_value += '+' if damage_value > 0

      if Configs.zv_battle_msg.damage_numbers.measurement == :percent
        damage_value = (damage_value.to_f * 100 / @target.max_hp).round
      end

      display_value += damage_value.to_s.to_pokemon_number
      return display_value
    end

    # Calculate the x-offset for the leftmost digit of the value
    # @param value [String] Displayable damage value
    # @return [Integer]
    def calculate_left_digit_x_offset(value)
      tmp_stack = UI::SpriteStack.new(viewport)
      tmp_stack.visible = false
      tmp_stack.z = -1
      tmp_text = tmp_stack.with_font(font_id) do
        tmp_stack.add_text(0, 0, _width = 0, _height = nil, value, _align = 0, outline_size)
      end
      return -tmp_text.real_width / 2
    ensure
      tmp_stack&.dispose
    end

    # Amount of time to wait between playing each digit's animation
    # @return [Float]
    def time_between_digits = 0.05

    # Color ID to use for the damage value
    # @param damage_value [Integer]
    # @return [Integer]
    def color_id(damage_value)
      settings = Configs.zv_battle_msg.damage_numbers
      return damage_value <= 0 ? settings.hurt_color : settings.heal_color
    end

    # Font ID
    # @return [Integer]
    def font_id = Configs.zv_battle_msg.damage_numbers.font_id

    # Offsets relative to a battler's sprite
    # @return [Array<Array<Integer>>]
    def position_offsets = [
      [0, -35], # Player battler
      [0, -2] # Enemy battler
    ]

    def critical_background_filename = 'critical_damage_numbers'
    def y_displacement = -4
    def bounce_duration = 0.3
    def animation_distortion_type = :zv_abs_function
    def wait_duration = 0.65
    def outline_size = Configs.zv_battle_msg.damage_numbers.outline_size
    def space_after_digit = 0
  end
end
