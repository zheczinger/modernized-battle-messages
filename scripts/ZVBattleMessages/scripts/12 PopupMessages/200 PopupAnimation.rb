module ZVBattleMsg
  # Base class for a popup message's animation.
  class PopupAnimation
    include Offsets3D

    @registered_animations = {}

    # @param popup [ZVBattleMsg::PopupMessage]
    # @param target_sprite [BattleUI::PokemonSprite]
    def initialize(popup, target_sprite)
      @popup = popup
      @target_sprite = target_sprite
    end

    # Create the animation
    # @return [Yuki::Animation::AnimationMixin]
    def create_animation
      raise 'This method must be implemented in the subclass'
    end

    class << self
      # Register a new popup animation
      # @param symbol [Symbol] symbol of the popup animation
      # @param klass [Class<PopupAnimation>] class of the popup animation
      def register(symbol, klass)
        @registered_animations[symbol] = klass
      end

      # Create a new popup animation
      # @param viewport [Viewport]
      # @param popup [ZVBattleMsg::PopupMessage]
      # @param target_sprite [BattleUI::PokemonSprite]
      # @return [PopupAnimation]
      def new(symbol, popup, target_sprite)
        klass = @registered_animations[symbol]
        raise "No popup animation registered for :#{symbol}" unless klass

        object = klass.allocate
        object.send(:initialize, popup, target_sprite)
        return object
      end
    end

    private

    # Offsets for most popup messages relative to a battler's sprite
    # @return [Array<Array<Integer>>] Player and enemy offsets in that order
    def position_offsets = [[0, -42], [0, -42]]
  end
end
