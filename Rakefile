require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

require "active_record"
require "erb"
require 'dotenv'
require 'yaml'

environment = ENV["RAILS_ENV"] || "development"
Dotenv.overload(".env", ".env.#{environment}", ".env.local", ".env.#{environment}.local")

RSPEC_ROOT = Pathname.new(File.dirname(__FILE__)).join("spec")

db_config = Pathname.new(RSPEC_ROOT).join("example_project", "config", "database.yml")
YAML::load(ERB.new(File.read(db_config)).result)

include ActiveRecord::Tasks
DatabaseTasks.database_configuration = YAML::load(ERB.new(File.read(db_config)).result)
DatabaseTasks.root = Pathname.new(RSPEC_ROOT).join("example_project")
DatabaseTasks.db_dir = 'db'
DatabaseTasks.migrations_paths = [File.join(DatabaseTasks.root, 'db/migrate')]
DatabaseTasks.env = environment
load 'active_record/railties/databases.rake'

require_relative "lib/dotenv_rails_db_tasks_fix"
# include DotenvRailsDbTasksFix
