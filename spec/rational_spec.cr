require "./spec_helper"

include Numbers
alias RNTuple = NamedTuple(num: Int32, den: Int32)
RN = Rational

describe Numbers do
  describe Rational do

    describe "#initialize" do
      Hash(RNTuple, RNTuple){
        {num: 14, den: 10} => {num: 7, den: 5},
        {num: 100, den: 50} => {num: 2, den: 1},
        {num: 138, den: 33} => {num: 46, den: 11},
      }
      .each do |k, v|
        it "initializes a rational number #{k[:num]}/#{k[:den]} in simplified form" do
          RN.new(k[:num], k[:den]).tap do |r|
            r.num.should eq v[:num]
            r.den.should eq v[:den]
          end
        end
      end
    end

    describe "#+" do
      context "when both inputs are rational numbers" do
        [
          [RN.new(10, 5), RN.new(3, 5), RN.new(13, 5)],
          [RN.new(68, 16), RN.new(50, 12), RN.new(101, 12)],
        ]
        .each do |rns|
          it "performs binary operation +" do
            sum = rns[0] + rns[1]
            sum.should eq rns[2]
          end
        end
      end

      context "when second input is integer" do
        [
          [RN.new(10, 5), 3, RN.new(5, 1)],
          [RN.new(68, 16), 50, RN.new(217, 4)],
        ]
        .each do |rns|
          it "performs binary operation +" do
            sum = rns[0] + rns[1].as Int32
            sum.should eq rns[2]
          end
        end
      end

      # context "when one of the inputs is negative" do
      #   [
      #     [RN.new(10, 14), -RN.new(3, 21), RN.new(4, 7)],
      #     [-RN.new(10, 5), RN.new(3, 10), -RN.new(17, 10)],
      #     [RN.new(68, 16), -50, -RN.new(183, 4)],
      #     [-RN.new(68, 16), 50, RN.new(-217, 4)]
      #   ]
      #   .each do |rns|
      #     it "performs binary operation +" do
      #       sum = rns[0] + rns[1]
      #       sum.should eq rns[2]
      #     end
      #   end
      # end
    end

    describe "#-" do
      context "when both argument is rational number" do
        [
          [RN.new(10, 5), RN.new(3, 5), RN.new(7, 5)],
          [RN.new(68, 16), RN.new(50, 12), RN.new(1, 12)],
        ]
        .each do |rns|
          it "performs binary operation {{op}}" do
            sum = rns[0] - rns[1]
            sum.should eq rns[2]
          end
        end
      end

      context "when argument is integer" do
        [
          [RN.new(10, 5), 3, RN.new(-1, 1)],
          [RN.new(68, 16), 50, RN.new(-183, 4)],
        ]
        .each do |rns|
          it "performs binary operation {{op}}" do
            sum = rns[0] - rns[1].as(Int32)
            sum.should eq rns[2]
          end
        end
      end

      context "when there is no argument" do
        it "reverses the sign of the rational number" do
          (-Rational.nine).negative?.should be_true
          (-Rational.new -9, -1).negative?.should be_true
          (-Rational.new -9, 1).negative?.should be_false
          (-Rational.new 9, -1).negative?.should be_false
        end
      end
    end

    describe "#*" do
      context "when both inputs are rational numbers" do
        [
          [RN.new(10, 5), RN.new(3, 5), RN.new(6, 5)],
          [RN.new(68, 16), RN.new(50, 12), RN.new(425, 24)],
        ]
        .each do |rns|
          it "performs binary operation {{op}}" do
            sum = rns[0] * rns[1]
            sum.should eq rns[2]
          end
        end
      end

      context "when second input is integer" do
        [
          [RN.new(10, 5), 3, RN.new(6, 1)],
          [RN.new(68, 16), 50, RN.new(425, 2)],
        ]
        .each do |rns|
          it "performs binary operation {{op}}" do
            sum = rns[0] * rns[1].as(Int32)
            sum.should eq rns[2]
          end
        end
      end
    end

    describe "#/" do
      context "when both inputs are rational numbers" do
        [
          [RN.new(10, 5), RN.new(3, 5), RN.new(10, 3)],
          [RN.new(68, 16), RN.new(50, 12), RN.new(51, 50)],
        ]
        .each do |rns|
          it "performs binary operation {{op}}" do
            sum = rns[0] / rns[1]
            sum.should eq rns[2]
          end
        end
      end

      context "when second input is integer" do
        [
          [RN.new(10, 5), 3, RN.new(2, 3)],
          [RN.new(68, 16), 50, RN.new(17, 200)],
        ]
        .each do |rns|
          it "performs binary operation {{op}}" do
            sum = rns[0] / rns[1].as(Int32)
            sum.should eq rns[2]
          end
        end
      end
    end

    describe "#to_i" do
      context "when rational number is of the form x/1" do
        it "returns x" do
          RN.new(45, 5).to_i.should eq 9
        end
      end

      context "when rational number is of the form x/y with y != 1" do
        it "returns floor(x/y)" do
          RN.new(45, 6).to_i.should eq 7
        end
      end
    end

    describe "#to_s" do
      context "when rational number is positive" do
        it "does not print sign" do
          Rational.new(-37, -99).to_s.should eq "37/99"
          Rational.new(37, 99).to_s.should eq "37/99"
        end
      end

      context "when rational number is negative" do
        it "prints the sign" do
          Rational.new(-37, 99).to_s.should eq "-37/99"
          Rational.new(37, -99).to_s.should eq "-37/99"
        end
      end

      context "when rational number is an integer" do
        it "does not print the denominator" do
          Rational.eight.to_s.should eq "8"
          (-Rational.eight).to_s.should eq "-8"
        end
      end
    end

  end
end