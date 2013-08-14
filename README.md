# ActiveSubsetValidator
[![Code Climate](https://codeclimate.com/github/paulnsorensen/active_subset_validator.png)](https://codeclimate.com/github/paulnsorensen/active_subset_validator)
[![Dependency Status](https://gemnasium.com/paulnsorensen/active_subset_validator.png)](https://gemnasium.com/paulnsorensen/active_subset_validator)

Provides subset validation for serialized arrays or sets in Active Record.
Checks whether given values for a serialized array or set are a subset of
a given array, set or proc against which to validate.

## Installation

Add this line to your application's Gemfile:

    gem 'active_subset_validator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_subset_validator

## Usage

    class Foo < ActiveRecord::Base
      validates :bars, subset: { of: %w(some list of strings) }
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
