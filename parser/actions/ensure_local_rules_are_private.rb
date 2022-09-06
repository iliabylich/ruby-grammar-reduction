def ensure_local_rules_are_private(grammar)
  used_by_files = ->(searching) do
    result = []
    grammar.rules.each do |rule|
      if rule.references.include?(searching)
        result << rule.filename
      end
    end

    result.uniq!

    if result.empty? && searching != 'program'
      raise "Can't find where rule #{searching} is used. Dead code?"
    end

    result
  end

  rules = grammar
    .rules
    .map { |rule| [used_by_files.call(rule.base_name), rule] }
    .reject { |(used_in, rule)| rule.base_name.start_with?('_') }
    .reject { |(used_in, rule)| rule.filename == 'parse.y' }
    .select { |(used_in, rule)| used_in == [rule.filename] }

  rules.each do |(used_in, rule)|
    puts "Rule #{rule.base_name} is used only in #{used_in.join(", ")}"
  end
end
