require_relative './rule'
require_relative './derivation'
require_relative './grammar'

require_relative './actions/find_rules_used_in_one_place'
require_relative './actions/ensure_local_rules_are_private'
require_relative './actions/find_dead_references'

grammar =
  Dir['**/*.y']
    .map { |filepath| [filepath, File.read(filepath)] }
    .map { |(filepath, src)| puts "Parsing #{filepath}"; Grammar.parse(filepath, src) }
    .reduce(&:merge)

puts grammar.pretty


find_rules_used_in_one_place(grammar)
ensure_local_rules_are_private(grammar)
find_dead_references(grammar)
