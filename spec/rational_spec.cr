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
          it "performs binary operation {{op}}" do
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
          it "performs binary operation {{op}}" do
            sum = rns[0] + rns[1].as Int32
            sum.should eq rns[2]
          end
        end
      end
    end

    describe "#-" do
      context "when both inputs are rational numbers" do
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

      context "when second input is integer" do
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
      it "returns x when rational number is of the form x/1" do
        RN.new(45, 5).to_i.should eq 9
      end

      it "returns floor(x/y) when rational number is of the form x/y with y != 1" do
        RN.new(45, 6).to_i.should eq 7
      end
    end

  end
end