module ZVBattleMsg
  module MoveToTarget
    private

    # Move the sprite stack to the target sprite's location
    # @param target_sprite [BattleUI::PokemonSprite]
    def move_to_target(target_sprite)
      self.x = (target_sprite.x + x_offset).to_i
      self.y = (target_sprite.y + y_offset).to_i
    end
  end
end
