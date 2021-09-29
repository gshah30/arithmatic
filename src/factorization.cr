require "./primes"
require "./power_product"

module Factorization
  def self.prime(n : Int32)
    negative = n < 0

    n = n.abs
    return PowerProduct.new Hash(Int32, Rational){ n => Rational.one }, negative if PrimesRepo.prime? n

    factor_hash = PrimesRepo
      .get_primes_upto(Math.sqrt(n).floor.to_i)
      .reduce(Hash(Int32, Int32).new(0)) do|factor_hash, p|
        while n % p == 0
          factor_hash[p] = factor_hash[p] + 1
          n //= p
        end
        factor_hash
      end

    factor_hash[n] += 1 if n != 1
    PowerProduct.new factor_hash.map{|k, v| {k, Rational.from(v)} }.to_h, negative
  end

  # TODO: handle negative inputs?
  def self.pairs(n : Int32) : Array(Tuple(Int32, Int32))
    (2..Math.sqrt(n).floor.to_i).compact_map{|i| n % i == 0 ? {i, n//i} : nil}
  end

  def self.prime(r : Rational)
    Factorization.prime(r.num) * Factorization.prime(r.den).inverse
  end

end

#TODO:  fix this. puts should automatically call to_s
# puts PrimesRepo.prime?(2_14_54_45_712)
# puts Factorization.prime(-2_14_54_45_712)
# puts Factorization.pairs(240)


# TODO: make this work for negative numbers
# puts Factorization.prime Rational.new(132, -22)
