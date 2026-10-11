module ZVBattleMsg
  # Handle animation where a move misses its target
  class UnaffectedAnimation < UI::SpriteStack
    include Offsets3D

    # @param viewport [Viewport]
    # @param target_sprite [BattleUI::PokemonSprite]
    def initialize(viewport, target_sprite)
      super(viewport, default_cache: :animation)
      @target_sprite = target_sprite

      self.z = target_sprite.z
      self.opacity = 0
      create_particles
      create_text
    end

    # Create the animation
    # @return [Yuki::Animation::AnimationMixin]
    def create_animation
      ya = Yuki::Animation

      return ya.player(
        ya.parallel(particle_animation(@target_sprite), text_animation(@target_sprite)),
        ya.dispose_sprite(self)
      )
    end

    private

    # Create sprite particles for the popup message
    def create_particles
      @particle_sprites = 20.times.map do
        sprite = add_sprite(0, 0, particle_sprite_filename)
        sprite.set_origin(sprite.width / 2, sprite.height / 2)
        next sprite
      end
    end

    # Draw text for the popup message
    def create_text
      settings = Configs.zv_battle_msg.replace_unaffected
      message = parse_text(Configs.zv_battle_msg.csv_id, settings.text_id)
      cx = calculate_left_digit_x_offset(message)

      @drawn_chars = message.each_char.map do |c|
        drawn_char = with_font(settings.font_id) do
          add_text(cx, 0, _width = 0, _height = nil, c, _align = 0, color: settings.color_id)
        end
        cx += drawn_char.real_width
        next drawn_char
      end
    end

    # Animation for the popup message's particles
    # @param target_sprite [BattleUI::PokemonSprite]
    # @return [Yuki::Animation::AnimationMixin]
    def particle_animation(target_sprite)

    end

    # Animation for the popup message's text
    # @param target_sprite [BattleUI::PokemonSprite]
    # @return [Yuki::Animation::AnimationMixin]
    def text_animation(target_sprite)
      ya = Yuki::Animation
      tx = target_sprite.x
      ty = target_sprite.y

      animations = @drawn_chars.map.with_index do |c, index|
        next ya.player(
          ya.wait(time_between_chars * index),
          ya.move_discreet(0, c, tx, ty, tx, ty),
          ya.opacity_change(0, c, 0, 255)
        )
      end

      return ya.player(
        ya.parallel(*animations),
        ya.wait(text_wait_duration),
        ya.send_command_to(self, :opacity=, 0)
      )
    end

    # Animation for the battler sprite in parallel of the popup message
    # @param target_sprite [BattleUI::PokemonSprite]
    # @return [Yuki::Animation::AnimationMixin]
    def particle_animation(target_sprite)
      ya = Yuki::Animation
      animation = ya.user_bank_relative_animation([friend_animation(target_sprite), foe_animation(target_sprite)])
      animation.resolver = { user: target_sprite }
      return animation
    end

    # Animation of player/ally battler sprite in parallel of the popup message
    # @param target_sprite [BattleUI::PokemonSprite]
    # @return [Yuki::Animation::AnimationMixin]
    def friend_animation(target_sprite)
      ya = Yuki::Animation
      tx = target_sprite.x
      ty = target_sprite.y
      dodge_x, dodge_y = sprite_travel_distances

      return ya.player(
        ya.move_discreet(sprite_dodge_duration, :user, tx, ty, tx - dodge_x, ty + dodge_y),
        ya.wait(sprite_wait_duration),
        ya.move_discreet(sprite_return_duration, :user, tx - dodge_x, ty + dodge_y, tx, ty)
      )
    end

    # Animation of enemy battler sprite in parallel of the popup message
    # @param target_sprite [BattleUI::PokemonSprite]
    # @return [Yuki::Animation::AnimationMixin]
    def foe_animation(target_sprite)
      ya = Yuki::Animation
      tx = target_sprite.x
      ty = target_sprite.y
      dodge_x, dodge_y = sprite_travel_distances

      return ya.player(
        ya.move_discreet(sprite_dodge_duration, :user, tx, ty, tx + dodge_x, ty - dodge_y),
        ya.wait(sprite_wait_duration),
        ya.move_discreet(sprite_return_duration, :user, tx + dodge_x, ty - dodge_y, tx, ty)
      )
    end

    # Calculate the x-offset for the leftmost character of the message
    # @param message [String]
    # @return [Integer]
    def calculate_left_digit_x_offset(message)
      tmp_stack = UI::SpriteStack.new(viewport)
      tmp_stack.visible = false
      tmp_stack.z = -1
      tmp_text = tmp_stack.with_font(font_id) do
        tmp_stack.add_text(0, 0, _width = 0, _height = nil, message, _align = 0)
      end
      return -tmp_text.real_width / 2
    ensure
      tmp_stack&.dispose
    end

    # Offsets for the popup message relative to a battler's sprite
    # @return [Array<Array<Integer>>] Player and enemy offsets in that order
    def position_offsets = [[0, -35], [0, -2]]

    def particle_sprite_filename = [25, 0]
    def sprite_dodge_duration   = 0.075
    def sprite_wait_duration    = 0.4
    def sprite_return_duration  = 0.2

    def text_y_wiggle      = 4
    def text_move_duration = 0.3
    def text_wait_duration = 0.65

    def color_id = 9
    def font_id  = 20
  end
end
