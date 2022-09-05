Rule = Struct.new(:name, :derivations, keyword_init: true) do
  def self.parse(src)
    src = src.strip

    head, *rest = src.lines.map(&:strip)
    name, derivation = head.split(":").map(&:strip)
    derivation = Derivation.parse(derivation)
    derivations = rest.map { |src| Derivation.parse(src.gsub('|', '')) }
    new(
      name: name,
      derivations: [derivation, *derivations]
    )
  end

  def pretty(offset:)
    out = []

    out << [' ' * (offset - name.length), name, ': ', derivations.first.pretty].join
    derivations[1..].each do |derivation|
      out << [' ' * offset, '| ', derivation.pretty].join
    end

    out.join("\n")
  end
end
