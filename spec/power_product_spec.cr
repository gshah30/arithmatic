require "./spec_helper"

describe PowerProduct do

  powers_hash = Hash(Int32, Rational){
      2 => Rational.five,
      3 => Rational.four,
      101 => Rational.two
    }

    powers_hash_negative = Hash(Int32, Rational){
      2 => -Rational.five,
      3 => -Rational.four,
      101 => Rational.two
    }

    power_hash =  Hash(Int32, Rational){ 2 => Rational.six }

  describe "#initialize" do

    context "when power product contains multiple powers" do
      it "initializes a power product" do
        pp = PowerProduct(Int32).new powers_hash, negative: true

        pp.bases.should eq powers_hash.keys
        pp.exponents.should eq powers_hash.values
        pp.negative?.should be_true
      end
    end

    context "when powers product contains a single power" do
      it "initializes a power product" do
        pp = PowerProduct(Int32).new power_hash

        pp.bases.should eq power_hash.keys
        pp.exponents.should eq power_hash.values
        pp.negative?.should be_false
      end
    end

    context "when powers product contains negative exponents" do
      it "initializes a power product" do
        pp = PowerProduct(Int32).new powers_hash_negative

        pp.bases.should eq powers_hash_negative.keys
        pp.exponents.should eq powers_hash_negative.values
        pp.negative?.should be_false
      end
    end
  end

  describe "#negate!" do
    it "changes the sign of a power product" do
      pp = PowerProduct(Int32).new powers_hash, negative: true
      pp.negative?.should be_true
      pp.negate!
      pp.negative?.should be_false
    end
  end

  describe "#*" do
    context "when multiplied with its own inverse" do
      context "when power product is negative" do
        it "produces unit power product" do
          pp = PowerProduct(Int32).new powers_hash, negative: true
          (pp * pp.inverse).should eq PowerProduct.unit
        end
      end

      context "when power product is positive" do
        it "produces unit power product" do
          pp = PowerProduct(Int32).new powers_hash
          (pp * pp.inverse).should eq PowerProduct.unit
        end
      end

    end

    context "when 2 power products of different signs are multiplied" do
      it "produces a power product with negative sign" do
          ppp = PowerProduct(Int32).new(power_hash) * PowerProduct(Int32).new(powers_hash, negative: true)
          ppp.negative?.should be_true
          ppp.bases.should eq power_hash.keys | powers_hash.keys
          ppp.exponents.should eq power_hash.merge(powers_hash){|k1, v1, v2| v1 + v2 }.select{|k, v| {k, v} if k != 1 && v != 0 }.values
      end
    end
  end

  describe "#inverse" do
    it "negates the sign of exponents" do
      pp = PowerProduct(Int32).new powers_hash, negative: true
      pp.inverse.exponents.should eq powers_hash.values.map{|e| -e }
      pp.negative?.should be_true
    end
  end

  describe "#==" do
    it "considers inverse of unit rational as equal to the rational" do
      (PowerProduct.unit.inverse == PowerProduct.unit).should be_true
    end

    it "considers unit rational as unequal to negative unit rational" do
      (PowerProduct.unit(negative: true) == PowerProduct.unit).should be_false
    end

    it "considers rational as unequal to its negative" do
      (PowerProduct.new(powers_hash) == PowerProduct.new(powers_hash, negative: true)).should be_false
    end
  end
end
