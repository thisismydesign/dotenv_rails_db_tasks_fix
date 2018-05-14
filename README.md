# DotenvRailsDbTasksFix

#### Fix for the issue when ActiveRecord `rake db:*` tasks are magically executed in both developement and test environments, but ENV vars loaded via Dotenv and DB config containing ENV vars don't pick up the change.

*You are viewing the README of the development version.*
​
| Branch | Status |
| ------ | ------ |
| Release | [![Build Status](https://travis-ci.org/thisismydesign/dotenv_rails_db_tasks_fix.svg?branch=release)](https://travis-ci.org/thisismydesign/dotenv_rails_db_tasks_fix)   [![Coverage Status](https://coveralls.io/repos/github/thisismydesign/dotenv_rails_db_tasks_fix/badge.svg?branch=release)](https://coveralls.io/github/thisismydesign/dotenv_rails_db_tasks_fix?branch=release)   [![Gem Version](https://badge.fury.io/rb/dotenv_rails_db_tasks_fix.svg)](https://badge.fury.io/rb/dotenv_rails_db_tasks_fix)   [![Total Downloads](http://ruby-gem-downloads-badge.herokuapp.com/dotenv_rails_db_tasks_fix?type=total)](https://rubygems.org/gems/dotenv_rails_db_tasks_fix) |
| Development | [![Build Status](https://travis-ci.org/thisismydesign/dotenv_rails_db_tasks_fix.svg?branch=master)](https://travis-ci.org/thisismydesign/dotenv_rails_db_tasks_fix)   [![Coverage Status](https://coveralls.io/repos/github/thisismydesign/dotenv_rails_db_tasks_fix/badge.svg?branch=master)](https://coveralls.io/github/thisismydesign/dotenv_rails_db_tasks_fix?branch=master) |


TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dotenv_rails_db_tasks_fix'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dotenv_rails_db_tasks_fix

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dotenv_rails_db_tasks_fix.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
