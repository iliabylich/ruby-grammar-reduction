require 'strscan'

def read_rule(src)
  if name = read_plain_rule(src)
    PlainRuleRef.new(name)
  else
    read_generic_rule(src)
  end
end

def read_plain_rule(src)
  if src.scan(/'/)
    "'" + src.scan_until(/'/)
  end
end

def read_generic_rule(src)
  if name = read_ident(src)
    if (args = read_generic_args(src)) && args.any?
      GenericRuleRef.new(name, args)
    else
      PlainRuleRef.new(name)
    end
  end
end

def read_ident(src)
  src.scan(/[_\w\d]+/)
end

def read_generic_args(src)
  pairs = {}
  if src.scan(/</)
    while !src.scan('>')
      src.skip(/\s+/)
      type, value = read_generic_item(src)
      pairs[type] = value
      src.skip(/,/)
    end
  end
  pairs
end

def read_generic_item(src)
  type = read_ident(src)
  src.skip(/\s+/)
  if !src.scan(/=/)
    raise "No = at #{src.inspect}"
  end
  src.skip(/\s+/)
  value = read_rule(src)
  [type, value]
end

Derivation = Struct.new(:rules, keyword_init: true) do
  def self.parse(src)
    src = StringScanner.new(src.strip)
    rules = []

    while !src.eos?
      src.skip(/\s+/)

      rule = read_rule(src)
      if rule.nil?
        raise "EOF at #{src.inspect}"
      end

      rules << rule
    end

    new(rules: rules)
  end

  def pretty
    rules.map(&:pretty).join(' ')
  end

  # Some rules can be generic, this is the reason why this method exists
  def used_rules(applied_with)

  end
end

PlainRuleRef = Struct.new(:name) do
  def pretty
    name
  end
end

GenericRuleRef = Struct.new(:name, :args) do
  def pretty
    args = self.args.map { |name, value| "#{name} = #{value.pretty}" }.join(",")
    "#{name}<#{args}>"
  end
end
