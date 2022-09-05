require_relative './rule'
require_relative './derivation'
require_relative './grammar'

grammar =
  Dir['**/*.y']
    .map { |filepath| File.read(filepath) }
    .map { |src| Grammar.parse(src) }
    .reduce(&:merge)

puts grammar.pretty
