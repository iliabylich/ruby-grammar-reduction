Grammar = Struct.new(:filename, :rules, keyword_init: true) do
  def self.parse(filename, src)
    src = src.strip

    # remove comments
    src = src.lines.reject { |line| line.strip.start_with?('//') }.join

    rules = src.split("\n\n").map(&:strip).reject(&:empty?).map { |src| Rule.parse(filename, src) }
    new(filename: filename, rules: rules)
  end

  def self.empty
    new(rules: [])
  end

  def merge(other)
    rules = self.rules + other.rules
    self.class.new(rules: rules)
  end

  def pretty
    max_length = rules.map { |rule| rule.name.pretty.length }.max
    rules.map { |rule| rule.pretty(offset: max_length) }.join("\n\n")
  end

  def references
    rules.flat_map(&:references)
  end
end
