require 'spec_helper'

describe ActiveSubsetValidator do
  describe "#is_a_set?" do
    it "returns true if an array is a set" do
      ActiveSubsetValidator.is_a_set?((1..20).to_a).should eq(true)
    end

    it "returns false if an array has duplicate values" do
      ActiveSubsetValidator.is_a_set?(%w(foo foo bar baz)).should eq(false)
    end

    it "returns true if a Set is a set" do
      ActiveSubsetValidator.is_a_set?(Set.new [1,2,4]).should eq(true)
    end

    it "returns true if a proc that is passed returns a proper array" do
      ActiveSubsetValidator.is_a_set?(Proc.new { %w(foo bar baz) }).should eq(true)
    end

    it "returns false if a proc that is passed returns an improper array" do
      ActiveSubsetValidator.is_a_set?(Proc.new { %w(foo foo bar baz) }).should eq(false)
    end

    it "returns true if a proc that is passed returns a set" do
      ActiveSubsetValidator.is_a_set?(Proc.new { Set.new [1,2,4] }).should eq(true)
    end

    it "returns true for valid procs with arguments" do
      ActiveSubsetValidator.is_a_set?(Proc.new { |a| Set.new a }, [1,2,3]).should eq(true)
    end
  end

  describe "#set_difference" do
    it "returns [] if the first array is a subset of the second array" do
      ActiveSubsetValidator.set_difference(%w(foo bar), %w(foo bar baz)).should eq([])
    end

    it "returns [] if the first and second arrays have the same values" do
      ActiveSubsetValidator.set_difference([1.0, 2.4, 3.9], [2.4, 1.0, 3.9]).should eq([])
    end

    it "returns the set difference when the first array has more values" do
      ActiveSubsetValidator.set_difference(%w(foo bar baz beans), %w(foo bar baz)).should eq(%w(beans))
    end

    it "returns the set difference when the first array is outside the set of the second" do
      ActiveSubsetValidator.set_difference(%w(beans), %w(foo bar baz)).should eq(%w(beans))
    end
  end
end