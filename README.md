# DotenvRailsDbTasksFix

#### Fix for the issue when ActiveRecord `rake db:*` tasks are magically executed in both developement and test environments, but environment variables loaded via `dotenv` are not picking up the change.

*You are viewing the README of the development version.*

| Branch | Status |
| ------ | ------ |
| Development | [![Build Status](https://travis-ci.org/thisismydesign/dotenv_rails_db_tasks_fix.svg?branch=master)](https://travis-ci.org/thisismydesign/dotenv_rails_db_tasks_fix)   [![Coverage Status](https://coveralls.io/repos/github/thisismydesign/dotenv_rails_db_tasks_fix/badge.svg?branch=master)](https://coveralls.io/github/thisismydesign/dotenv_rails_db_tasks_fix?branch=master) |

If you're using environment variables is your `database.yml` and load them via `Dotenv` chances are you also ran into this annoying issue in your development environment:

`database.yml`
```
development:
  database:     <%= ENV['DB_NAME'] %>
  # ...
test:
  database:     <%= ENV['DB_NAME'] %>
  # ...
```

`.env.development`
```
DB_NAME=development
# ...
```

`.env.test`
```
DB_NAME=test
# ...
```

```
$ rails db:create
=>
Created database 'app_development'
Database 'app_development' already exists
```

```
$ rails db:create
=>
rails aborted!
ActiveRecord::EnvironmentMismatchError: You are attempting to modify a database that was last run in `test` environment.
You are running in `development` environment. If you are sure you want to continue, first set the environment using:

        bin/rails db:environment:set RAILS_ENV=development
```

Using this gem you can do:

`Rakefile`
```
# ...
require "dotenv_rails_db_tasks_fix"
DotenvRailsDbTasksFix.activate
```

```
$ rails db:create
=>
Created database 'app_development'
Created database 'app_test'
```

## Explanation

ActiveRecord has this feature that they execute DB tasks in `test` env as well if the current env is `dev`. They're pretty "neat" about it ([see](https://github.com/rails/rails/blob/v5.1.5/activerecord/lib/active_record/tasks/database_tasks.rb#L300)):
`environments << "test" if environment == "development"`. This happens in the middle of execution so there's no way `Dotenv` could nicely intervene and even if they did there are things already loaded at this point (e.g. env vars are interpolated to configs). Dotenv's recommendation is to use different env var names (e.g. `TEST_DB_NAME`, `DEVELOPMENT_DB_NAME`) but that would be counter-intuitive. Instead here we monkey patch `ActiveRecord::Tasks::DatabaseTasks` to explicitly reload env vars and the DB config when it switches to test env.

*It's invasive and ugly but it only affects the development environment (so it's low-risk) and restores the expected behaviour of this widely used feature therefore sparing the annoyance and possible effort of investigation.*

See [this issue](https://github.com/thisismydesign/dotenv_rails_db_tasks_fix) and [this article](http://www.zhuwu.me/blog/posts/rake-db-tasks-always-runs-twice-in-development-environment).

## Caveats

- Database config is expected to reside in `#{DatabaseTasks.root}/config/database.yml` (if you're using Rails `DatabaseTasks.root == Rails.root`)
- Requires ActiveRecord >= 5.1.5, ~> 5.1.6 (althoguh following this solution it would be easy to extend support for other versions)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dotenv_rails_db_tasks_fix'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dotenv_rails_db_tasks_fix

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dotenv_rails_db_tasks_fix.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
