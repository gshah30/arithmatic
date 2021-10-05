require "./utils"

module Numbers

  class InvalidRationalInitializationException < Exception
    def initialize(value : String)
      super "A rational number can not be initialized from the string #{value}"
    end
  end

  # should this be made struct?
  class Rational

    macro define_rational_integers(hash_node)
      {% for name, number in hash_node %}
      def self.{{name}}
        Rational[{{number}}]
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

    def self.[](i : Int32)
      Rational.new i, 1
    end

    def self.[](s : String)
      s = "#{s}/1" if s.split('/').size == 1

      raise InvalidRationalInitializationException.new s if !(/[0-9]+\/[0-9]+/ =~ s)

      num, den = s.split('/').map &.to_i
      Rational.new num, den
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
      r = Rational[i]
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
          self {{op.id}} Rational[i]
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
