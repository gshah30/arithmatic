require "./spec_helper"

describe Utils do
  describe ".gcd" do

    {
      [8, 28, 16, 32, 88] => 4,
      [30, 72_u32, 600] => 6,
      [49, 70, 35, 0] => 7
    }
    .each do |k, v|
      it "returns the GCD of #{k.to_s}" do
        Utils.gcd(k).should eq v
      end
    end

    it "returns GCD of 2 integers" do
      Utils.gcd(30, 21).should eq 3
      Utils.gcd(21_u32, 30_u32).should eq 3
      Utils.gcd(21_u32, 30).should eq 3
    end

    it "returns integer as GCD of that integer with 0" do
      Utils.gcd(30_u32, 0).should eq 30
      Utils.gcd(0, 30).should eq 30
    end

  end

  describe ".quotients_from_division_by_gcd" do
    {
      [8, 28, 16, 32, 88] => [2, 7, 4, 8, 22],
      [30, 72_u32, 600] => [5, 12, 100],
      [49, 70, 35, 0] => [7, 10, 5, 0]
    }
    .each do |k, v|
      it "returns #{v} as quotients remaining after division of #{k} with GCD" do
        Utils.quotients_from_division_by_gcd(k).should eq v
      end
    end
  end
end