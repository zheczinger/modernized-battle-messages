module Configs
  module Project
    class ZVBattleMsg
      # Relative path to a graphics file for this plugin starting from graphics/animations/.
      # @param path [Array<String>]
      # @return [String]
      def animation_path(*path)
        return File.join(@prefix, *path)
      end

      # Relative path to a SE file for this plugin starting from audio/se/.
      # @param filename [String]
      # @return [String]
      def se_path(filename)
        return "#{@prefix}-#{filename}"
      end
    end
  end
end
