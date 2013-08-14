require 'coveralls'
Coveralls.wear!

require 'active_subset_validator'
require 'support/active_record'

RSpec.configure do |config|
  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end