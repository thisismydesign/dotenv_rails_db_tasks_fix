require "bundler/gem_tasks"
require "rspec/core/rake_task"
require_relative "lib/dotenv_rails_db_tasks_fix"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

require "erb"
require 'yaml'

RSPEC_ROOT = Pathname.new(File.dirname(__FILE__)).join("spec")
environment = ENV["RAILS_ENV"] || "development"
db_config = Pathname.new(RSPEC_ROOT).join("example_project", "config", "database.yml")

Dotenv.overload(".env", ".env.#{environment}", ".env.local", ".env.#{environment}.local")

include ActiveRecord::Tasks
DatabaseTasks.database_configuration = YAML::load(ERB.new(File.read(db_config)).result)
DatabaseTasks.root = Pathname.new(RSPEC_ROOT).join("example_project")
DatabaseTasks.db_dir = 'db'
DatabaseTasks.migrations_paths = [File.join(DatabaseTasks.root, 'db/migrate')]
DatabaseTasks.env = environment
load 'active_record/railties/databases.rake'

DotenvRailsDbTasksFix.activate
