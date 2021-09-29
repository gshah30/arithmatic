require "./spec_helper"



describe Factorization do
  describe ".prime" do
    context "when input is positive integer" do
      it "factorizes composite number as product of prime powers" do
        Factorization.prime(744).should eq(
          PowerProduct(Int32).new Hash(Int32, Rational){
            2 => Rational.three,
            3 => Rational.one,
            31 => Rational.one
          }
        )
      end

      it "factorizes prime number as prime to the power 1" do
        Factorization.prime(1).should eq PowerProduct(Int32).new Hash(Int32, Rational){ 1 => Rational.one }
        Factorization.prime(2).should eq PowerProduct(Int32).new Hash(Int32, Rational){ 2 => Rational.one }
        Factorization.prime(3).should eq PowerProduct(Int32).new Hash(Int32, Rational){ 3 => Rational.one }

        Factorization.prime(37).should eq PowerProduct(Int32).new Hash(Int32, Rational){ 37 => Rational.one }
      end
    end

    context "when input is negative integer" do
      it "factorizes composite number as product of prime powers with negative sign" do
        Factorization.prime(-744).should eq(
          PowerProduct(Int32).new Hash(Int32, Rational){
            2 => Rational.three,
            3 => Rational.one,
            31 => Rational.one
          }, negative: true
        )
      end

      it "factorizes prime number as prime to the power 1 with negative sign" do
        Factorization.prime(-1).should eq PowerProduct(Int32).new Hash(Int32, Rational){ 1 => Rational.one }, negative: true
        Factorization.prime(-2).should eq PowerProduct(Int32).new Hash(Int32, Rational){ 2 => Rational.one }, negative: true
        Factorization.prime(-3).should eq PowerProduct(Int32).new Hash(Int32, Rational){ 3 => Rational.one }, negative: true

        Factorization.prime(-37).should eq PowerProduct(Int32).new Hash(Int32, Rational){ 37 => Rational.one }, negative: true
      end
    end

    context "when input is a rational number" do
      it "for positive input generates prime factorization with some negative powers" do
        Factorization.prime(Rational.seven).should eq PowerProduct(Int32).new Hash(Int32, Rational){ 7 => Rational.one }
        Factorization.prime(Rational.new 77, 11).should eq PowerProduct(Int32).new Hash(Int32, Rational){ 7 => Rational.one }

        Factorization.prime(Rational.new 606, 132).should eq(
          PowerProduct(Int32).new Hash(Int32, Rational){
            2 => -Rational.one,
            11 => -Rational.one,
            101 => Rational.one }
        )
      end

      it "for negative input generates prime factorization with some negative powers and negative sign" do
        Factorization.prime(-Rational.seven).should eq PowerProduct(Int32).new Hash(Int32, Rational){ 7 => Rational.one }, negative: true
        Factorization.prime(-Rational.new 77, 11).should eq PowerProduct(Int32).new Hash(Int32, Rational){ 7 => Rational.one }, negative: true

        Factorization.prime(-Rational.new 606, 132).should eq(
          PowerProduct(Int32).new Hash(Int32, Rational){
            2 => -Rational.one,
            11 => -Rational.one,
            101 => Rational.one
          }, negative: true
        )
      end
    end

    # TODO: write tests for to_s

  end
end