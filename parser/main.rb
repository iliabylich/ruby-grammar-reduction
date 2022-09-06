require_relative './rule'
require_relative './derivation'
require_relative './grammar'

grammar =
  Dir['**/*.y']
    .map { |filepath| [filepath, File.read(filepath)] }
    .map { |(filepath, src)| puts "Parsing #{filepath}"; Grammar.parse(src) }
    .reduce(&:merge)

puts grammar.pretty
