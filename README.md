# ActiveSubsetValidator
[![Code Climate](https://codeclimate.com/github/paulnsorensen/active_subset_validator.png)](https://codeclimate.com/github/paulnsorensen/active_subset_validator)
[![Dependency Status](https://gemnasium.com/paulnsorensen/active_subset_validator.png)](https://gemnasium.com/paulnsorensen/active_subset_validator)
[![Gem Version](https://badge.fury.io/rb/active_subset_validator.png)](http://badge.fury.io/rb/active_subset_validator)
[![Build Status](https://travis-ci.org/paulnsorensen/active_subset_validator.png)](https://travis-ci.org/paulnsorensen/active_subset_validator)
[![Coverage Status](https://coveralls.io/repos/paulnsorensen/active_subset_validator/badge.png?branch=master)](https://coveralls.io/r/paulnsorensen/active_subset_validator?branch=master)

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

Add to your models like so:

    class Foo < ActiveRecord::Base
      validates :bars, subset: { of: %w(some list of strings) }
    end

The `:of` parameter may contain an `Array` or `Set` or a `Proc` or `lambda` that returns either type.

## Testing

You may write your tests similar to # ActiveSubsetValidator
[![Code Climate](https://codeclimate.com/github/paulnsorensen/active_subset_validator.png)](https://codeclimate.com/github/paulnsorensen/active_subset_validator)
[![Dependency Status](https://gemnasium.com/paulnsorensen/active_subset_validator.png)](https://gemnasium.com/paulnsorensen/active_subset_validator)
[![Gem Version](https://badge.fury.io/rb/active_subset_validator.png)](http://badge.fury.io/rb/active_subset_validator)
[![Build Status](https://travis-ci.org/paulnsorensen/active_subset_validator.png)](https://travis-ci.org/paulnsorensen/active_subset_validator)
[![Coverage Status](https://coveralls.io/repos/paulnsorensen/active_subset_validator/badge.png?branch=master)](https://coveralls.io/r/paulnsorensen/active_subset_validator?branch=master)

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

Add to your models like so:

```ruby
    class Article < ActiveRecord::Base
      validates :categories, subset: { of: %w(foo bar baz ) }
    end
```
The `:of` parameter may contain an `Array` or `Set` or a `Proc` or `lambda` that returns either type.

This gem is basically  a subclasss of  `ActiveModel::EachValidator` so you should have all the nifty options to pass to the `validates` method as well.

```ruby
    class Comment < ActiveRecord::Base
      attr_accessible :content, :tags,
      validates :tags,
        subset: { of: %w(some list of strings) },
        if: ->(comment) { comment.some_method? },
        allow_nil: false
    end
```

## Testing

You may write your tests similar to the following to ensure that the subset
validator is working. Here's an example using [FactoryGirl](https://github.com/thoughtbot/factory_girl) and [RSpec](https://github.com/rspec/rspec):

```ruby
    it "ensures times_taken contains only values within the proper set" do
     med = build(:medication)
     med.times_taken = %w(as_needed breakfast lunch dinner bedtime)
     med.should have(:no).errors_on(:times_taken)
     med.times_taken << "midnight"
     med.errors_on(:times_taken).should include("is not a subset of the list")
    end
```

Alternatively, if you use [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers), you could do this:

```ruby
    it { should allow_value(%w(good-val-0 good-val-1)).for(foo) }
    it { should_not allow_value(%w(bad-val-0 bad-val-1)).for(:foo) }
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
the following to ensure that the subset
validator is working. Here's an example using FactoryGirl and RSpec:

    it "ensures times_taken contains only values within the proper set" do
     med = build(:medication)
     med.times_taken = %w(as_needed breakfast lunch dinner bedtime)
     med.should have(:no).errors_on(:times_taken)
     med.times_taken << "midnight"
     med.errors_on(:times_taken).should include("is not a subset of the list")
    end

Alternatively, if you use shoulda-matchers, you could do this:

    it { should allow_value(%w(treated_for_adhd been_hospitalized wears_glasses_or_contacts)).for(:enabled_health_details) }
    it { should_not allow_value(%w(random crap)).for(:enabled_health_details) }

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
