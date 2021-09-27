require "./primes.cr"

module Factorization
  def self.prime(n : Int32)
    PrimesRepo
      .get_primes_upto(Math.sqrt(n).floor.to_i)
      .reduce(Hash(Int32, Int32).new(0)) {|factor_hash, p|
        while n % p == 0
          factor_hash[p] += 1
          n //= p
        end
        factor_hash
      }
      .tap {|factor_hash| factor_hash[n] += 1 if n != 1 }
  end

  def self.pairs(n : Int32) : Array(Tuple(Int32, Int32))
    (2..Math.sqrt(n).floor.to_i).compact_map{|i| n % i == 0 ? {i, n//i} : nil}
  end
end

puts Factorization.prime(2_14_54_45_712)
puts Factorization.pairs(240)
