module Utils
  def self.gcd(a : Int32 | UInt32, b : Int32 | UInt32)
    b == 0 ? a : gcd b, a % b
  end

  def self.gcd(integers : Array(Int32 | UInt32))
    integers.reduce 0 {|acc, i| gcd i, acc }
  end

  def self.quotients_from_division_by_gcd(integers : Array(Int32 | UInt32))
    the_gcd = gcd integers
    integers.map &.//(the_gcd)
  end
end