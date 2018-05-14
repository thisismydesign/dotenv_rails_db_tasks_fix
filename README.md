# DotenvRailsDbTasksFix

#### Fix for the issue when ActiveRecord `rake db:*` tasks are magically executed in both developement and test environments, but environment variables loaded via `dotenv` are not picking up the change.

*You are viewing the README of version [v0.1.0](https://github.com/thisismydesign/dotenv_rails_db_tasks_fix/releases/tag/v0.1.0).*

| Branch | Status |
| ------ | ------ |
| Development | [![Build Status](https://travis-ci.org/thisismydesign/dotenv_rails_db_tasks_fix.svg?branch=master)](https://travis-ci.org/thisismydesign/dotenv_rails_db_tasks_fix)   [![Coverage Status](https://coveralls.io/repos/github/thisismydesign/dotenv_rails_db_tasks_fix/badge.svg?branch=master)](https://coveralls.io/github/thisismydesign/dotenv_rails_db_tasks_fix?branch=master) |

If you're using environment variables in your `database.yml` and load them via `Dotenv` chances are you also ran into this annoying issue in your development environment:

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
$ rails db:setup
=>
Created database 'app_development'
Database 'app_development' already exists
```

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

Using this gem you can do:

`Rakefile`
```
# ...
require "dotenv_rails_db_tasks_fix"
DotenvRailsDbTasksFix.activate
```

```
$ rails db:setup
=>
Created database 'app_development'
Created database 'app_test'
```

## Explanation

ActiveRecord has this feature that it executes DB tasks in `test` env as well if the current env is `development`. ([see](https://github.com/rails/rails/blob/v5.1.5/activerecord/lib/active_record/tasks/database_tasks.rb#L300):
`environments << "test" if environment == "development"`). This happens in the middle of execution so there's no way for `dotenv` to nicely intervene and even if they did there are things already loaded at this point (e.g. env vars are interpolated to configs). Dotenv's recommendation is to use different env var names (e.g. `TEST_DB_NAME`, `DEVELOPMENT_DB_NAME`) but that would be counter-intuitive. Instead here we monkey patch `ActiveRecord::Tasks::DatabaseTasks` to explicitly reload env vars and the DB config when it switches to test env.

*It's invasive and ugly but it only affects the development environment (so it's low-risk) and restores the expected behaviour of this widely used feature therefore sparing the annoyance and possible effort of investigation.*

See [this issue](https://github.com/thisismydesign/dotenv_rails_db_tasks_fix) and [this article](http://www.zhuwu.me/blog/posts/rake-db-tasks-always-runs-twice-in-development-environment).

## Caveats

- Database config is expected to reside in Rails default `#{DatabaseTasks.root}/config/database.yml` (if you're using Rails `DatabaseTasks.root == Rails.root`)
- Requires ActiveRecord >= 5.1.5, ~> 5.1.6 (because there're slight differences in the private API, althoguh following this solution it would be easy to extend support for other versions)
- There's some weirdness with `Rails.env` vs `DatabaseTasks.env`. From trial-and-error it seems changing `DatabaseTasks.env` to reflect the current execution env will result in issues (with e.g. `db:setup` and `db:reset`), while changing `Rails.env` is actually required for `db:setup` to work correctly. [This fix](https://github.com/thisismydesign/dotenv_rails_db_tasks_fix/blob/be83ad6f97e4c1eb4bcfb5a2860eb3b53d7ff063/lib/dotenv_rails_db_tasks_fix.rb#L24-L28) seems to work for the use cases I tried but it's good to keep this in mind in case any similar issue presents.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dotenv_rails_db_tasks_fix'
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
