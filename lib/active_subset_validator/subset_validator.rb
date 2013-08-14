class SubsetValidator < ActiveModel::EachValidator
   ERROR_MESSAGE = "An argument must be supplied for the :of option " <<
   "of the configuration hash and must evaluate to an array or a set"

  def check_validity!
    if options[:of].respond_to?(:call)
      return
    elsif options[:of].is_a?(Array) || options[:of].is_a?(Set)
      unless ActiveSubsetValidator.is_a_set? options[:of]
        raise ArgumentError, ERROR_MESSAGE
      end
    else
      raise ArgumentError, ERROR_MESSAGE
    end
  end

  def validate_each(record, attribute, value)
    message = options[:message] ? options[:message] : "is not a subset of the list"
    allow_nil = options[:allow_nil] === false ? false : true

    if options[:of].respond_to?(:call)
      superset = options[:of].call(record)
      unless ActiveSubsetValidator.is_a_set? superset
        raise ArgumentError, ERROR_MESSAGE
      end
    else
      superset = options[:of]
    end
    
    if value.nil?
      unless allow_nil
        record.errors[attribute] << "cannot be nil"
      end
    else
      unless ActiveSubsetValidator.set_difference(value, superset).empty?
        record.errors[attribute] << message
      end
    end
  end
end
