module ZVBattleMsg
  class TempState
    # "Stack frame" for critical hit booleans for create_hp_animation_handler.
    # @return [Array<Array<Boolean>>]
    attr_accessor :critical_hits

    # "Stack frame" for status changes for status_change.
    # @return [Array<Array<Symbol, PFM::PokemonBattler>>]
    attr_accessor :status_changes

    # "Stack frame" for stat changes for show_stat_animation
    # @return [Array<Symbol>]
    attr_accessor :stat_changes

    # Whether to currently silence incoming messages
    # @return [Boolean]
    attr_accessor :quiet_messages

    def initialize
      @critical_hits = []
      @status_changes = []
      @stat_changes = []
      @quiet_messages = false
    end

    def with_pushed_attributes(**attributes)
      push_attr_value = proc { |a, value| send(a).push(value) }
      pop_attr_value = proc { |a, _| send(a).pop }
      attributes.each(&push_attr_value)
      yield
    ensure
      attributes.each(&pop_attr_value)
    end
  end
end
