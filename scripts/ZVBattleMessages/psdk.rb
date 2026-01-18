proc do
  raise 'This plugin requires PSDK .26.50 or newer' if PSDK_VERSION < 6706

  check_methods = proc do |klass, method_names|
    name_conflicts = method_names.find_all { |n| klass.method_defined?(n) }.map { |n| "#{klass}.#{n}" }
    raise "Name conflict with #{name_conflicts.join(', ')}" unless name_conflicts.empty?
  end

  check_methods.call(
    Battle::Visual, %i[
      zv_show_unaffected_animation
      zv_show_miss_animation
      zv_show_perish_animation
      zv_create_hit_popup_animation
      zv_create_damage_numbers_animation
    ]
  )
end.call
