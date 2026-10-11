module Battle
  class Logic
    module ZVBattleMsgLogic
      attr_reader :zv_temp_state

      # [psdk-override]
      def initialize(...)
        super
        @zv_temp_state = ZVBattleMsg::TempState.new
      end
    end
    prepend ZVBattleMsgLogic
  end
end
