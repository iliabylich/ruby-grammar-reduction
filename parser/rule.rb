Rule = Struct.new(:name, :derivations, keyword_init: true) do
  def self.parse(src)
    src = src.strip

    head, *rest = src.lines.map(&:strip)
    name, derivation = head.split(":", 2).map(&:strip)

    if name.include?('<')
      name, args = name.split('<', 2)
      args = args.delete_suffix('>')
      args = args.split(', ')
      name = GenericRuleName.new(name, args)
    else
      name = PlainRuleRef.new(name)
    end

    derivation = Derivation.parse(derivation)
    derivations = rest.map { |src| src.gsub('|', '').strip }.reject(&:empty?).map { |src| Derivation.parse(src) }
    new(
      name: name,
      derivations: [derivation, *derivations]
    )
  end

  def pretty(offset:)
    out = []

    name = self.name.pretty

    out << [' ' * (offset - name.length), name, ': ', derivations.first.pretty].join
    derivations[1..].each do |derivation|
      out << [' ' * offset, '| ', derivation.pretty].join
    end

    out.join("\n")
  end

  def base_name
    name.name
  end
end

PlainRuleName = Struct.new(:name) do
  def pretty
    name
  end
end

GenericRuleName = Struct.new(:name, :args) do
  def pretty
    "#{name}<#{args.join(', ')}>"
  end
end
