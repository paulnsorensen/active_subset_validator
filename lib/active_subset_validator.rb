require 'active_model'
require "active_subset_validator/version"
require "active_subset_validator/subset_validator"
require "active_subset_validator/railtie" if defined? Rails

module ActiveSubsetValidator
  SET_DIFF_ERROR = "Arguments much match types upon evaluation. " <<
              "Expects Array or Set."

  def self.is_a_set? obj, *args
    if obj.respond_to?(:call)
      obj = obj.call *args
    end
    if obj.is_a?(Set)
      return true
    elsif obj.is_a?(Array)
      return obj.to_set.to_a == obj
    else
      return false
    end
  end

  def self.set_difference obj1, obj2
    if obj1.is_a?(Array) && obj2.is_a?(Array)
      (obj1.to_set - obj2.to_set).to_a
    elsif obj1.is_a?(Set) && obj2.is_a?(Set)
      obj1 - obj2
    else
      raise ArgumentError, SET_DIFF_ERROR
    end
  end
end
