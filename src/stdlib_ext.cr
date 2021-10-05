struct Int32
  def self.unit : Int32
    1
  end
end

# def add(x : Int32)
#   x + 1
# end

# def sub(x : Int32)
#   x - 1
# end

# def mult(x : Int32)
#   x * 9
# end

add = ->(x : Int32) { x+ 1 }
mult = ->(x : Int32) { x * 10 }

x = add << mult
p! x.call(10)