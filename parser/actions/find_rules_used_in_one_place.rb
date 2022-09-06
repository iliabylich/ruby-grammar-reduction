def find_rules_used_in_one_place(grammar)
  count = ->(searching) do
    result = 0

    grammar.rules.each do |rule|
      rule.derivations.each do |derivation|
        derivation.rules.each do |rule_ref|
          if searching == rule_ref.name
            result += 1
          end
        end
      end
    end

    result
  end

  rules = grammar.rules.select { |rule| count.call(rule.base_name) == 1 }

  allowed = %w[alias array hash literal preexe postexe undef]
  puts "Rules used once:"
  rules.each do |rule|
    name = rule.base_name
    next if name.start_with?('_')
    next if allowed.include?(name)
    puts "+ #{name}"
  end
end
