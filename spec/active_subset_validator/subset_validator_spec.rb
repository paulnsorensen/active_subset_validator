require 'spec_helper'

class Comment < ActiveRecord::Base
end

describe SubsetValidator do
  it "inherits from ActiveModel::EachValidator" do
    SubsetValidator.superclass.should equal ActiveModel::EachValidator
  end

  describe "#check_validity!" do
    before(:each) do
      Comment.send(:serialize, :tags, Array)
      Comment.reset_callbacks(:validate)
    end
    
    it "fails on an invalid array" do
      expect {
        Comment.validates :tags, subset: { of: %w(foo bar baz baz) }
      }.to raise_error ArgumentError
    end
    it "fails on an invalid argument" do
      expect {
        Comment.validates :tags, subset: { of: Hash.new }
      }.to raise_error ArgumentError
    end
    it "does not fail when passed a lambda" do
      expect {
        Comment.validates :tags, subset: { of: lambda { |a| Set.new a } }
      }.not_to raise_error
    end
  end

  describe "#validate_each" do
    before(:each) do
      Comment.reset_callbacks(:validate)
    end

    it "raises an error when the attribute is Array and :of type is Set" do
      Comment.send(:serialize, :tags, Array)
      Comment.validates :tags, subset: { of: Set.new([1,2,3]) }
      comment = Comment.new
      comment.tags = %w(python java)
      expect { comment.valid? }.to raise_error ArgumentError
    end

    it "raises an error when the attribute is Set and :of type is Array" do
      Comment.send(:serialize, :tags, Set)
      Comment.validates :tags, subset: { of: %w(tee hee) }
      comment = Comment.new
      comment.tags = Set.new %w(python java)      
      expect { comment.valid? }.to raise_error ArgumentError
    end

    it "raises an error when proc evaluates to an incorrect type" do
      Comment.send(:serialize, :tags, Set)
      Comment.validates :tags, subset: { of: Proc.new { |r| r.class.to_s } }
      comment = Comment.new
      comment.tags = Set.new %w(python java)
      expect { comment.valid? }.to raise_error ArgumentError
    end

    it "adds an error for the invalid attribute when :of is a Proc" do
      Comment.send(:serialize, :tags, Set)
      Comment.send(:define_method, 'valid_set') do
        Set.new %w(ruby python scala)
      end
      Comment.validates :tags, subset: { of: Proc.new { |r| r.valid_set } }
      comment = Comment.new
      comment.tags = Set.new %w(python java)
      comment.errors_on(:tags).should include "is not a subset of the list"
    end

    it "adds an error for the invalid attribute when :of is a Set" do
      Comment.send(:serialize, :tags, Set)
      Comment.validates :tags, subset: { of: Set.new([1,2,3,5]) }
      comment = Comment.new
      comment.tags = Set.new [2,4]
      comment.errors_on(:tags).should include "is not a subset of the list"
    end

    it "adds an error for the invalid attribute when :of is an Array" do
      Comment.send(:serialize, :tags, Array)
      Comment.validates :tags, subset: { of: %w(Atlanta Cleveland Chicago) }
      comment = Comment.new
      comment.tags = %w(Chicago Boston)
      comment.errors_on(:tags).should include "is not a subset of the list"
    end

    it "adds a custom error message for an invalid attribute when passed" do
      Comment.send(:serialize, :tags, Array)
      Comment.validates :tags, subset: { 
        of: %w(Atlanta Cleveland Chicago), 
        message: "contains an out-of-range city"
      }
      comment = Comment.new
      comment.tags = %w(Chicago Boston)
      comment.errors_on(:tags).should include "contains an out-of-range city"
    end

    it "correctly validates a serialized Set when :of is a Set" do
      Comment.send(:serialize, :tags, Set)
      Comment.send(:define_method, 'valid_set') do
        Set.new %w(ruby python scala)
      end
      Comment.validates :tags, subset: { of: Set.new(%w(java scala python)) }
      comment = Comment.new
      comment.tags = Set.new %w(python java)
      comment.should have(:no).errors_on(:tags)
    end
  
    it "correctly validates a serialized Set when :of is a Proc" do
      Comment.send(:serialize, :tags, Set)
      Comment.send(:define_method, 'valid_set') do
        Set.new %w(ruby python scala)
      end
      Comment.validates :tags, subset: { of: Proc.new { |r| r.valid_set } }
      comment = Comment.new
      comment.tags = Set.new %w(python ruby)
      comment.should have(:no).errors_on(:tags)
    end

    it "correctly validates a serialized Array when :of is a Array" do
      Comment.send(:serialize, :tags, Array)
      Comment.validates :tags, subset: { of: %w(Atlanta Boston Chicago) }
      comment = Comment.new
      comment.tags = %w(Chicago Boston)
      comment.should have(:no).errors_on(:tags)
    end
  
    it "correctly validates a serialized Array when :of is a Proc" do
      Comment.send(:serialize, :tags, Array)
      Comment.validates :tags, subset: { of: Proc.new { [1,3,9,27,81] } }
      comment = Comment.new
      comment.tags = [9,27]
      comment.should have(:no).errors_on(:tags)
    end

    it "allows nil if :allow_nil is true (default)" do
      Comment.send(:serialize, :tags, Array)
      Comment.validates :tags, subset: { of: [1,3,9,27,81] }
      comment = Comment.new
      comment.tags = nil
      comment.should have(:no).errors_on(:tags)
    end

    it "doesn't allow nil if :allow_nil is false" do
      Comment.send(:serialize, :tags, Array)
      Comment.validates :tags, subset: { of: [1,3,9,27,81], allow_nil: false }
      comment = Comment.new
      comment.tags = nil
      comment.errors_on(:tags).should include "cannot be nil"
    end    
  end
end