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
end

puts Time.local.millisecond

puts PrimesRepo.cache_stopper
puts Factorization.prime(10_70_54_45_712)
puts PrimesRepo.cache_stopper

puts puts Time.local.millisecond
