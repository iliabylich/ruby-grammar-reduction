Derivation = Struct.new(:names, keyword_init: true) do
  def self.parse(src)
    src = src.strip
    names = src.split(' ').map(&:strip)
    new(names: names)
  end

  def pretty
    names.join(' ')
  end
end
