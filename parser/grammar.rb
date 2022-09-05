Grammar = Struct.new(:rules, keyword_init: true) do
  def self.parse(src)
    src = src.strip

    # remove comments
    src = src.lines.reject { |line| line.strip.start_with?('//') }.join

    rules = src.split("\n\n").map(&:strip).reject(&:empty?).map { |src| Rule.parse(src) }
    new(rules: rules)
  end

  def self.empty
    new(rules: [])
  end

  def merge(other)
    rules = self.rules + other.rules
    self.class.new(rules: rules)
  end

  def pretty
    max_length = rules.map { |rule| rule.name.length }.max
    rules.map { |rule| rule.pretty(offset: max_length) }.join("\n\n")
  end
end
