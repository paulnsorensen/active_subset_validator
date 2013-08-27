require 'spec_helper'

describe ActiveSubsetValidator do
  describe ".is_a_set?" do
    it "returns true if an array is a set" do
      expect(ActiveSubsetValidator.is_a_set?((1..20).to_a)).to eq(true)
    end

    it "returns false if an array has duplicate values" do
      expect(ActiveSubsetValidator.is_a_set?(%w(foo foo bar baz))).to eq(false)
    end

    it "returns true if a Set is a set" do
      expect(ActiveSubsetValidator.is_a_set?(Set.new [1,2,4])).to eq(true)
    end

    it "returns true if a proc that is passed returns a proper array" do
      expect(ActiveSubsetValidator.is_a_set?(Proc.new { %w(foo bar baz) })).to eq(true)
    end

    it "returns false if a proc that is passed returns an improper array" do
      expect(ActiveSubsetValidator.is_a_set?(Proc.new { %w(foo foo bar baz) })).to eq(false)
    end

    it "returns true if a proc that is passed returns a set" do
      expect(ActiveSubsetValidator.is_a_set?(Proc.new { Set.new [1,2,4] })).to eq(true)
    end

    it "returns true for valid procs with arguments" do
      expect(ActiveSubsetValidator.is_a_set?(Proc.new { |a| Set.new a }, [1,2,3])).to eq(true)
    end
  end

  describe ".set_difference" do
    it "returns [] if the first array is a subset of the second array" do
      expect(ActiveSubsetValidator.set_difference(%w(foo bar), %w(foo bar baz))).to eq([])
    end

    it "returns [] if the first and second arrays have the same values" do
      expect(ActiveSubsetValidator.set_difference([1.0, 2.4, 3.9], [2.4, 1.0, 3.9])).to eq([])
    end

    it "returns the set difference when the first array has more values" do
      expect(ActiveSubsetValidator.set_difference(%w(foo bar baz beans), %w(foo bar baz))).to eq(%w(beans))
    end

    it "returns the set difference when the first array is outside the set of the second" do
      expect(ActiveSubsetValidator.set_difference(%w(beans), %w(foo bar baz))).to eq(%w(beans))
    end
  end
end