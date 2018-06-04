# DotenvRailsDbTasksFix

#### Fix for the issue when ActiveRecord `rake db:*` tasks are magically executed in both development and test environments, but environment variables loaded via `dotenv` are not picking up the change.

*You are viewing the README of version [v0.2.1](https://github.com/thisismydesign/dotenv_rails_db_tasks_fix/releases/tag/v0.2.1). You can find other releases [here](https://github.com/thisismydesign/dotenv_rails_db_tasks_fix/releases).*

| Branch | Status |
| ------ | ------ |
| Release | [![Build Status](https://travis-ci.org/thisismydesign/dotenv_rails_db_tasks_fix.svg?branch=release)](https://travis-ci.org/thisismydesign/dotenv_rails_db_tasks_fix)   [![Coverage Status](https://coveralls.io/repos/github/thisismydesign/dotenv_rails_db_tasks_fix/badge.svg?branch=release)](https://coveralls.io/github/thisismydesign/dotenv_rails_db_tasks_fix?branch=release)   [![Gem Version](https://badge.fury.io/rb/dotenv_rails_db_tasks_fix.svg)](https://badge.fury.io/rb/dotenv_rails_db_tasks_fix)   [![Total Downloads](http://ruby-gem-downloads-badge.herokuapp.com/dotenv_rails_db_tasks_fix?type=total)](https://rubygems.org/gems/dotenv_rails_db_tasks_fix) |
| Development | [![Build Status](https://travis-ci.org/thisismydesign/dotenv_rails_db_tasks_fix.svg?branch=master)](https://travis-ci.org/thisismydesign/dotenv_rails_db_tasks_fix)   [![Coverage Status](https://coveralls.io/repos/github/thisismydesign/dotenv_rails_db_tasks_fix/badge.svg?branch=master)](https://coveralls.io/github/thisismydesign/dotenv_rails_db_tasks_fix?branch=master) |

If you rely on environment variables loaded via `Dotenv` chances are you also ran into this issue. E.g.:

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

In your development environment:

```
$ rails db:setup
=>
Created database 'app_development'
Database 'app_development' already exists
```

It seems like the task is executed twice for the development environment (more on that later..) and you also often encounter an `EnvironmentMismatchError`:

```
$ rails db:setup
=>
Database 'app_development' already exists
Database 'app_development' already exists
rails aborted!
ActiveRecord::EnvironmentMismatchError: You are attempting to modify a database that was last run in `test` environment.
You are running in `development` environment. If you are sure you want to continue, first set the environment using:

        bin/rails db:environment:set RAILS_ENV=development
```

#### Using this gem you can do:

`Rakefile`
```ruby
# ...
DotenvRailsDbTasksFix.activate if ActiveRecord::Tasks::DatabaseTasks.env.eql?("development") # or Rails.env
```

```
$ rails db:setup
=>
Created database 'app_development'
Created database 'app_test'
```

## Explanation

ActiveRecord has this feature that it executes DB tasks in `test` env as well if the current env is `development` ([see](https://github.com/rails/rails/blob/v5.1.5/activerecord/lib/active_record/tasks/database_tasks.rb#L300):
`environments << "test" if environment == "development"`). So ActiveRecord actually executes for different environments but not via a fresh start. This makes it impossible for `dotenv` to pick this change up in a clean way. But even if it did there are things already loaded at this point which dotenv should not touch. E.g. reinitializing the database config after an environment change should rather be the responsibility of ActiveRecord.

Dotenv's recommendation is to use different env var names (e.g. `TEST_DB_NAME`, `DEVELOPMENT_DB_NAME`) but that would be counter-intuitive. Instead via this gem `ActiveRecord::Tasks::DatabaseTasks` is monkey patched to explicitly reload env vars and the DB config when it switches to test env. *This approach undoubtedly has its cons but in this case it only affects the development environment and restores the expected behaviour of this widely used feature therefore sparing the annoyance and possible effort of investigation.*

See also [this issue](https://github.com/rails/rails/issues/32926) and [this article](http://www.zhuwu.me/blog/posts/rake-db-tasks-always-runs-twice-in-development-environment).

## Caveats

- Outside of `development` environment `DotenvRailsDbTasksFix.activate` will `raise` and will _not_ monkey patch
- Database config is expected to reside in Rails default `#{DatabaseTasks.root}/config/database.yml` (if you're using Rails `DatabaseTasks.root == Rails.root`)
- Requires ActiveRecord >= 5.1.5, ~> 5.1.6 (because there're slight differences in the private API, althoguh following this solution it would be easy to extend support for other versions)
- There's some weirdness with `Rails.env` vs `DatabaseTasks.env`. From trial-and-error it seems changing `DatabaseTasks.env` to reflect the current execution env will result in issues (with e.g. `db:setup` and `db:reset`), while changing `Rails.env` is actually required for `db:setup` to work correctly. [This fix](https://github.com/thisismydesign/dotenv_rails_db_tasks_fix/blob/v0.2.0/lib/dotenv_rails_db_tasks_fix.rb#L25-L29) seems to work for the use cases I tried but it's good to keep this in mind in case any similar issue presents. This might be due to this issue: https://github.com/rails/rails/issues/32910
- If you introduce this to a project currently in use a final `db:environment:set` might be needed if prompted

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dotenv_rails_db_tasks_fix', group: :development
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dotenv_rails_db_tasks_fix

## Feedback

Any feedback is much appreciated.

I can only tailor this project to fit use-cases I know about - which are usually my own ones. If you find that this might be the right direction to solve your problem too but you find that it's suboptimal or lacks features don't hesitate to contact me.

Let me know if you make use of this project so that I can prioritize further efforts.

## Conventions

This gem is developed using the following conventions:
- [Bundler's guide for developing a gem](http://bundler.io/v1.14/guides/creating_gem.html)
- [Better Specs](http://www.betterspecs.org/)
- [Semantic versioning](http://semver.org/)
- [RubyGems' guide on gem naming](http://guides.rubygems.org/name-your-gem/)
- [RFC memo about key words used to Indicate Requirement Levels](https://tools.ietf.org/html/rfc2119)
- [Bundler improvements](https://github.com/thisismydesign/bundler-improvements)
- [Minimal dependencies](http://www.mikeperham.com/2016/02/09/kill-your-dependencies/)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/thisismydesign/dotenv_rails_db_tasks_fix.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
