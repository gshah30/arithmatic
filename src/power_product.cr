require "log"

require "./rational"

include Numbers

class PowerProduct(T)
  def self.unit(negative = false)
    PowerProduct(Int32).new Hash(Int32, Rational){ 1 => Rational.one }, negative
  end

  @negative : Bool

  def initialize(powers : Hash(T, Int32), negative : Bool = false)
    @negative = negative
    @powers = powers.map{|k, v| {k, Rational[v]} }
  end

  def initialize(powers : Hash(T, Rational), negative : Bool = false)
    @negative = negative
    @powers = powers
  end

  def wrap_base(type : U.class) forall U
    PowerProduct(U).new powers.map{|k, v| {type.new(k), v} }.to_h
  end

  def negative?
    @negative
  end

  def negate!
    @negative = !@negative
  end

  getter powers : Hash(T, Rational)

  def bases
    @powers.keys
  end

  def exponents
    @powers.values
  end

  def inverse
    PowerProduct(T).new @powers.map{|k ,v| {k , -v} }.to_h, @negative
  end

  def *(ps : PowerProduct(U)) : PowerProduct(T | U) forall U
    powers = @powers.merge(ps.powers){|k1, v1, v2| v1 + v2 }
                            .select{|k, v| {k, v} if k != 1 && v != 0 }

    if powers.size == 0 || powers.keys == [1]
      powers = Hash(Int32, Rational){ 1 => Rational[1] }
    end

    PowerProduct.new powers, @negative^ps.negative?
  end

  def <<(base : T, exponent : Rational)
    if powers.has_key? base
      Log.info { "Key #{base} not added to the power product as it is already present" }
      false
    else
      powers[base] = exponent
      true
    end
  end

  def <<(powers_product : PowerProduct(T))
    powers_product.reduce(self) do |acc, kv|
      acc << { base: kv[0], exponent: kv[1] }
    end
  end

  def ==(ps : PowerProduct(T))
    return true if (@powers.size == 0 || @powers.keys == [1]) && (ps.powers.size == 0 || ps.powers.keys == [1]) && @negative == ps.negative?
    @powers == ps.powers && @negative == ps.negative?
  end

  def to_s(io : IO)
    io << "-1 " if @negative
    @powers.each do |k, v|
      io << k << '^' << v << ' '
    end
  end

end