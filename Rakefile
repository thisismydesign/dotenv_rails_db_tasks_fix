require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "dotenv"
require "yaml"
require "erb"

require_relative "lib/dotenv_rails_db_tasks_fix"
require_relative "spec/support/active_record_tasks"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

RSPEC_ROOT = Pathname.new(File.dirname(__FILE__)).join("spec")
environment = ENV["RAILS_ENV"] || "development"
project_path = Pathname.new(RSPEC_ROOT).join("example_project")
class Seeder; def load_seed; end; end
# Root path has to be execution path, see: https://github.com/rails/rails/issues/32910
# Config is expected at `#{root}/config/database.yml`
# If the issue above is fixed it can be moved to `#{root}/spec/example_project/config/database.yml`
root = Pathname.new(".")
db_config = root.join("config", "database.yml")
db_dir = root.join("config")

Dotenv.overload(".env", ".env.#{environment}", ".env.local", ".env.#{environment}.local")
config = YAML::load(ERB.new(File.read(db_config)).result)

load_active_record_tasks(database_configuration: config, root: root, db_dir: db_dir, seed_loader: Seeder.new)

DotenvRailsDbTasksFix.activate
