require "./utils"

module Numbers
  class Rational
    def self.from(i : Int32)
      Rational.new i, 1
    end

    @numerator : Int32
    @denominator : Int32

    def initialize(numerator : Int32, denominator : Int32)
      numerator, denominator = Utils.quotients_from_division_by_gcd([numerator, denominator])

      @numerator = numerator
      @denominator = denominator
    end

    def num
      @numerator
    end

    def den
      @denominator
    end

    getter numerator, denominator

    def ==(r : Rational)
      num == r.num && den == r.den
    end

    def +(r : Rational)
      Rational.new num*r.den+r.num*den, den*r.den
    end

    def -(r : Rational)
      Rational.new num*r.den-r.num*den, den*r.den
    end

    def *(r : Rational)
      Rational.new num*r.num, den*r.den
    end

    def /(r : Rational)
      Rational.new num*r.den, den*r.num
    end

    macro define_bin_operations_with_integers(*bin_ops)
      {% for op in bin_ops %}
        def {{op.id}}(i : Int32)
          self {{op.id}} Rational.from(i)
        end
      {% end %}
    end

    define_bin_operations_with_integers(:+, :-, :*, :/)

    def to_i
      den == 1 ? num : num//den
    end

  end
end
