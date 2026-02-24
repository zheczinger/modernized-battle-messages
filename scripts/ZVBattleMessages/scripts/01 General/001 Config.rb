module Configs
  module Project
    class ZVBattleMsg
      # Class to manage damage popup numbers settings
      class DamageNumbers
        MEASUREMENTS = %i[percent points]

        # Is this enabled?
        # @return [Boolean]
        attr_reader :enable

        # Unit of measurement to display damage popup numbers in
        # @return [Symbol] :percent, :points
        #   :percent = As a percentage of the battler's max HP
        #   :points = As an exact HP quantity
        attr_reader :measurement

        # String representation for the unit of measurement
        # @return [String]
        attr_reader :unit_text

        # Font ID of the damage popup numbers
        # @return [Integer]
        attr_reader :font_id

        # Size of the text outline
        # @return [Integer]
        attr_reader :outline_size

        # Color ID of the damage popup numbers
        # @return [Integer]
        attr_reader :hurt_color

        # Color ID of the healing popup numbers
        # @return [Integer]
        attr_reader :heal_color

        # @param enable [Boolean]
        # @param measurement [String]
        # @param unit_text [String]
        # @param font_id [Integer]
        # @param outline_size [Integer]
        # @param hurt_color [Integer]
        # @param heal_color [Integer]
        def initialize(
          enable: true,
          measurement: :percent,
          unit_text: '',
          font_id: 0,
          outline_size: 1,
          hurt_color: 9,
          heal_color: 13
        )
          @enable       = enable
          @measurement  = measurement.to_sym
          @unit_text    = unit_text
          @font_id      = font_id
          @outline_size = outline_size
          @hurt_color   = hurt_color
          @heal_color   = heal_color

          raise 'Invalid measurement choice' unless MEASUREMENTS.include?(@measurement)
        end
      end

      # Class to manage message silencing settings
      class SilenceMessages
        class Message
          # ID of the CSV file where this message is located
          # @return [Integer]
          attr_reader :csv_id

          # Text ID where this message is located
          # @return [Integer]
          attr_reader :text_id

          # @param csv_id [Integer]
          # @param text_id [Integer]
          def initialize(csv_id:, text_id:)
            @csv_id  = csv_id
            @text_id = text_id
          end
        end

        # Is this enabled?
        # @return [Boolean]
        attr_reader :enable

        # List of messages
        # @return [Array<Message>]
        attr_reader :messages

        # @param enable [Boolean]
        # @param messages [Array<Hash>]
        def initialize(messages:, enable: true)
          @enable = enable
          @messages = messages.map { |h| Message.new(**h) }
        end
      end

      # Class to manage replacement settings for the move usage message
      class ReplaceMoveUsage
        class MoveName
          # Font ID for the move's name
          # @return [Integer]
          attr_reader :font_id

          # Color ID for the name of the move's user
          attr_reader :color_id

          # Position of the move's name relative to the move's UI bar
          # @return [Array<Integer>]
          attr_reader :relative_position

          # @param font_id [Integer]
          # @param color_id [Integer]
          # @param relative_position [Array<Integer>]
          def initialize(font_id: 0, color_id: 9, relative_position: [30, 16])
            @font_id = font_id
            @relative_position = relative_position
          end
        end

        class UserIcon
          # Show the icon of the move's user?
          # @return [Boolean]
          attr_reader :display

          # Position of the icon relative to the move's UI bar
          # @return [Array<Integer>]
          attr_reader :relative_position

          # @param display [Boolean]
          # @param relative_position [Array<Integer>]
          def initialize(display: true, relative_position: [0, 0])
            @display = display
            @relative_position = relative_position
          end
        end

        class UserName
          # Show the name of the move's user?
          # @return [Boolean]
          attr_reader :display

          # Font ID for the name of the move's user
          # @return [Integer]
          attr_reader :font_id

          # Color ID for the name of the move's user
          attr_reader :color_id

          # Position of the name relative to the move's UI bar
          # @return [Array<Integer>]
          attr_reader :relative_position

          # @param display [Boolean]
          # @param font_id [Integer]
          # @param color_id [Integer]
          # @param relative_position [Array<Integer>]
          def initialize(display: true, font_id: 20, color_id: 9, relative_position: [30, 0])
            @display = display
            @font_id = font_id
            @relative_position = relative_position
          end
        end

        # Is this enabled?
        # @return [Boolean]
        attr_reader :enable

        # Position of the move's UI bar
        # @return [Array<Integer>]
        attr_reader :position

        # Settings for the move's name in the move's UI bar
        # @return [MoveName]
        attr_reader :move_name

        # Settings for the icon of the move's user in the move's UI bar
        # @return [UserIcon]
        attr_reader :user_icon

        # Settings for the name of the move's user in the move's UI bar
        # @return [UserName]
        attr_reader :user_name

        def initialize(
          enable: true,
          position: [40, 280],
          move_name: {},
          user_icon: {},
          user_name: {}
        )
          @enable    = enable
          @position  = position
          @move_name = MoveName.new(**move_name)
          @user_icon = UserIcon.new(**user_icon)
          @user_name = UserName.new(**user_name)
        end
      end

      # ID of this plugin's CSV file
      # @return [Integer]
      attr_accessor :csv_id

      # Prefix name for this plugin's assets, used in the following ways:
      # - graphics/animations/$PREFIX/* (Here, prefix is the subfolder name)
      # - audio/se/$PREFIX-* (Here, prefix is the prefix of the filenames, followed by '-')
      # @return [String]
      attr_accessor :prefix

      # Replace the messages displayed for super-effective and not-very-effective hits with popup animations?
      # @return [Boolean]
      attr_accessor :replace_effectiveness

      # Replace the message displayed for a critical hit with a popup animation?
      # @return [Boolean]
      attr_accessor :replace_critical_hit

      # Replace the message displayed when a move doesn't affect a battler with a popup animation?
      # @return [Boolean]
      attr_accessor :replace_unaffected

      # Replace the message displayed when an attack misses with a popup and battler animation?
      # @return [Boolean]
      attr_accessor :replace_miss

      # Replace the message displayed when a battler's stat stage changes with a popup animation?
      # @return [Boolean]
      # @note This also speeds up the vanilla stat change animation, which the popup will overlap with.
      attr_accessor :replace_stat_change

      # Replace the message displayed for a battler's perish count with a custom animation?
      # @return [Boolean]
      attr_accessor :replace_perish

      # Damage popup numbers settings
      # @return [DamageNumbers]
      attr_reader :damage_numbers

      # Settings for replacing a move usage message
      # @return [ReplaceMoveUsage]
      attr_reader :replace_move_usage

      # Set damage popup numbers settings
      # @param settings [Hash]
      def damage_numbers=(settings)
        @damage_numbers = DamageNumbers.new(**settings)
      end

      # Set battle scene messages to silence
      # @param settings [Hash]
      def silence_messages=(settings)
        @silence_messages = SilenceMessages.new(**settings)
      end

      # Set settings for replacing the move usage message
      # @param settings [Hash]
      def replace_move_usage=(settings)
        @replace_move_usage = ReplaceMoveUsage.new(**settings)
      end

      # Check if a battle scene message should be silenced
      # @param csv_id [Integer] CSV ID of the battle scene message
      # @param text_id [Integer] Text ID of the battle scene message
      # @return [Boolean]
      def silence_message?(csv_id, text_id)
        return false unless $scene.is_a?(Battle::Scene)
        return false unless @silence_messages.enable

        return @silence_messages.messages.any? do |m|
          next m.csv_id == csv_id && m.text_id == text_id
        end
      end

      # Silence a battle scene message if applicable depending on settings
      # @param message [String]
      # @param csv_id [Integer] CSV ID of the message
      # @param text_id [Integer] Text ID of the message
      def apply_silence_settings(message, csv_id, text_id)
        return unless silence_message?(csv_id, text_id)

        message.singleton_class.prepend(::ZVBattleMsg::SilentSceneMessage)
      end

      # Relative path to a graphics file for this plugin starting from graphics/animations/
      # @param filename [String]
      # @return [String]
      def animation_path(filename)
        return File.join(prefix, filename)
      end

      # Relative path to a SE file for this plugin starting from audio/se/
      # @param filename [String]
      # @return [String]
      def se_path(filename)
        return "#{prefix}-#{filename}"
      end

      # rubocop:disable Metric/MethodLength
      def initialize
        self.csv_id                = 93_208
        self.prefix                = 'zv-battle-messages'

        self.replace_effectiveness = true
        self.replace_critical_hit  = true
        self.replace_unaffected    = true
        self.replace_miss          = true
        self.replace_stat_change   = true
        self.replace_perish        = true

        self.damage_numbers = {}
        self.replace_move_usage = {}

        self.silence_messages = {
          messages: [
            {
              csv_id: 19,
              text_id: 243,
              comment: 'poison/toxic status end of turn'
            },
            {
              csv_id: 19,
              text_id: 261,
              comment: 'burn status end of turn'
            },
            {
              csv_id: 19,
              text_id: 905,
              note: 'standard energy drain'
            }
          ]
        }
      end
      # rubocop:enable Metric/MethodLength
    end
  end

  # @!method self.zv_battle_msg
  # @return [Configs::Project::ZVBattleMsg]
  register(:zv_battle_msg, File.join('plugins', 'zv_battle_msg_config'), :json, false, Project::ZVBattleMsg)
end
