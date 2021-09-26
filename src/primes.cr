module PrimesRepo
  macro gen_primes(n)
    {% primes = [1, 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97] %}
    # prime[division_limit] should always be the prime number immediately less than sqrt of (primes.last + 1)
    # used this logic because could not find a way to calculate sqrt of (primes.last + 1) at compile time
    {% division_limit = 4 %}

    {% for i in (primes.last + 1)..n %}

      {% if primes[division_limit+1]**2 <= i %}
        {% division_limit += 1 %}
      {% end %}

      {% unless primes[1..division_limit].any?{|p| i % p == 0 } %}
        {% primes << i %}
      {% end %}

    {% end %}

    @@primes = {{primes}}
    @@division_limit = {{division_limit}}
  end

  gen_primes(1_00_000)

  def self.get_closest_primes(n : Int32) : Tuple(Int32, Int32, Int32) | Nil
    return nil if n < 2

    if n < @@primes.last
      greater_index = @@primes.index{|p| p >= n }.as Int32

      return {@@primes[greater_index], @@primes[greater_index], greater_index} if @@primes[greater_index] == n
      {@@primes[greater_index-1], @@primes[greater_index], greater_index-1}

    elsif n == @@primes.last
      {@@primes.last, @@primes.last, @@primes.size-1}
    else
      lesser_prime = greater_prime = lesser_prime_index = nil
      (@@primes.last+1..2*n).each do |i|
        if @@primes[@@division_limit+1]**2 <= i
          @@division_limit += 1
        end

        unless @@primes[1..@@division_limit].any?{|p| i % p == 0 }
          if i == n
            lesser_prime = greater_prime = i
            lesser_prime_index = @@primes.size
          end

          if (lesser_prime.nil? || greater_prime.nil?) && i > n
            lesser_prime = @@primes.last
            greater_prime = i
            lesser_prime_index = @@primes.size-1
          end
          @@primes << i
        end
      end
      {lesser_prime.as(Int32), greater_prime.as(Int32), lesser_prime_index.as(Int32)}
    end
  end

  def self.get_nth_prime(n)
    if n < @@primes.size
      @@primes[n]
    else
      while n >= @@primes.size
        i = @@primes.last + 1

        @@division_limit += 1 if @@primes[@@division_limit+1]**2 <= i

        unless @@primes[1..@@division_limit].any?{|p| i % p == 0 }
          # lesser_prime = greater_prime = i if i = n
          @@primes << i
          return @@primes.last if n < @@primes.size
        end
      end
    end
  end

  def self.get_primes_in_index_range(start : Int32, finish : Int32)
    # generate primes till finish if not already generated
    get_nth_prime(finish)

    @@primes[start..finish]
  end

  def self.get_primes_in_range(n1 : Int32, n2 : Int32)
    return nil if n1 > n2
    n1 = 2 if n1 < 2

    n1_lesser_prime, n1_greater_prime, n1_lesser_index = get_closest_primes(n1).as Tuple(Int32, Int32, Int32)
    n2_lesser_prime, n2_lesser_prime, n2_lesser_index = get_closest_primes(n2).as Tuple(Int32, Int32, Int32)

    first_index = n1_lesser_prime == n1_greater_prime ? n1_lesser_index : n1_lesser_index+1
    last_index = n2_lesser_index

    @@primes[first_index..last_index]
  end

  def self.get_primes_upto(n : Int32) : Array(Int32)
    get_primes_in_range(2, n).as Array(Int32)
  end

  def self.prime?(n : Int32)
    return @@primes.includes?(n) if n <= @@primes.last

    get_primes_upto(Math.sqrt(n).floor.to_i).any?{|p| n % p == 0}
  end

  def self.cache_size
    @@primes.size
  end

  def self.cache_stopper
    @@primes.last
  end
end
