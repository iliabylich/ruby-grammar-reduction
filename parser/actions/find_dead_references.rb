def find_dead_references(grammar)
  grammar.rules.each do |rule|
    rule.references.each do |ref|
      next if ref.start_with?("'") && ref.end_with?("'")
      next if ref[0] == 't' && ref[1..].upcase == ref[1..]
      next if ref[0] == 'k' && ref[1..].upcase == ref[1..]
      next if %w[T T1 T2 T3 Item Sep Body].include?(ref)
      next if ref == 'none'

      unless grammar.rules.map(&:base_name).include?(ref)
        raise "Rule #{ref} is not declared"
      end
    end
  end
end
