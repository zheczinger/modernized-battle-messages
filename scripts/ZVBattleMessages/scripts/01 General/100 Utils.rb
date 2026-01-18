module ZVBattleMsg
  module_function

  # @return [String]
  def home_language
    return 'en'
  end

  # @param filename [String]
  # @return [String]
  def translate_animation_filename(filename)
    new_filename = filename
    new_filename += "_#{$options.language}" if $options.language != home_language
    return new_filename if RPG::Cache.animation_exist?(new_filename)

    return filename
  end

  # @param method_name [Symbol]
  # @param klass [Class]
  # @return [Boolean]
  def m_defined?(method_name, klass = self.class)
    return klass.method_defined?(method_name, true) || klass.private_method_defined?(method_name, true)
  end
end
