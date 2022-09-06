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

  grammar.rules.group_by { |rule| count.call(rule.base_name) }[1]
end
