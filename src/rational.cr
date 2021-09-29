require "./utils"

module Numbers
  # should this be made struct?
  class Rational

    macro define_rational_integers(hash_node)
      {% for name, number in hash_node %}
      def self.{{name}}
        Rational.from {{number}}
      end
      {% end %}
    end

    define_rational_integers({
      zero: 0,
      one: 1,
      two: 2,
      three: 3,
      four: 4,
      five: 5,
      six: 6,
      seven: 7,
      eight: 8,
      nine: 9
    })

    def self.from(i : Int32)
      Rational.new i, 1
    end

    # @negative : Bool

    def initialize(numerator : Int32, denominator : Int32)
      negative = numerator * denominator < 0

      numerator, denominator = Utils.quotients_from_division_by_gcd([numerator.abs, denominator.abs])
      @numerator = negative ? -numerator : numerator
      @denominator = denominator
    end

    def num
      @numerator
    end

    def den
      @denominator
    end

    def negative?
      num < 0
    end

    getter numerator : Int32, denominator : Int32

    def ==(r : self)
      num == r.num && den == r.den
    end

    def ==(i : Int32)
      r = Rational.from i
      num == r.num && den == r.den
    end

    def +(r : self)
      Rational.new num*r.den+r.num*den, den*r.den
    end

    def -(r : self)
      Rational.new num*r.den-r.num*den, den*r.den
    end

    def *(r : self)
      Rational.new num*r.num, den*r.den
    end

    def /(r : self)
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

    def -
      Rational.new(-num, den)
    end

    def to_s(io : IO) : Nil
      io << (den == 1 ? "#{num}" : "#{num}/#{den}")
    end

    # def inspect(io : IO)
    #   to_s(io)
    # end

  end
end
