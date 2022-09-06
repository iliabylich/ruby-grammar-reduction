require_relative './rule'
require_relative './derivation'
require_relative './grammar'

require_relative './actions/find_rules_used_in_one_place'

grammar =
  Dir['**/*.y']
    .map { |filepath| [filepath, File.read(filepath)] }
    .map { |(filepath, src)| puts "Parsing #{filepath}"; Grammar.parse(src) }
    .reduce(&:merge)

puts grammar.pretty

puts "Rules used once:"
allowed = %w[alias array hash literal preexe postexe undef]
find_rules_used_in_one_place(grammar).each do |rule|
  name = rule.base_name
  next if name.start_with?('_')
  next if allowed.include?(name)
  puts "+ #{name}"
end
