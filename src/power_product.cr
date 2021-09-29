require "./rational"

include Numbers

class PowerProduct(T)
  def self.unit(negative = false)
    PowerProduct(Int32).new Hash(Int32, Rational){ 1 => Rational.one }, negative
  end

  @negative : Bool

  def initialize(powers : Hash(T, Int32), negative : Bool = false)
    @negative = negative
    @powers = powers.size == 0 ? Hash(Int32, Rational){ 1 => Rational.one } : powers.map{|k, v| {k, Rational.from(v)} }
  end

  def initialize(powers : Hash(T, Rational), negative : Bool = false)
    @negative = negative
    @powers = powers.size == 0 || powers.keys == [1] ? Hash(Int32, Rational){ 1 => Rational.one } : powers
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
    PowerProduct(T).new @powers.map{|k ,v| {k , -v} }.to_h, negative?
  end

  def *(ps : PowerProduct(U)) : PowerProduct(T | U) forall U
    PowerProduct.new @powers.merge(ps.powers){|k1, v1, v2| v1 + v2 }
                            .select{|k, v| {k, v} if k != 1 && v != 0 }, @negative^ps.negative?
  end

  def ==(ps : PowerProduct(T))
    powers == ps.powers && negative? == ps.negative?
  end

  def to_s(io : IO)
    io << "-1 " if @negative
    @powers.each do |k, v|
      io << k << '^' << v << ' '
    end
  end

  # def inspect(io : IO)
  #   to_s(io)
  # end
end
