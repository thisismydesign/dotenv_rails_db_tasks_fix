require "bundler/gem_tasks"
require "rspec/core/rake_task"
require_relative "lib/dotenv_rails_db_tasks_fix"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

require "erb"
require 'yaml'
require 'dotenv'
require 'active_record'

RSPEC_ROOT = Pathname.new(File.dirname(__FILE__)).join("spec")
environment = ENV["RAILS_ENV"] || "development"
db_config = Pathname.new(RSPEC_ROOT).join("example_project", "config", "database.yml")

Dotenv.overload(".env", ".env.#{environment}", ".env.local", ".env.#{environment}.local")

class Seeder; def load_seed; end; end

include ActiveRecord::Tasks
DatabaseTasks.database_configuration = YAML::load(ERB.new(File.read(db_config)).result)
DatabaseTasks.root = Pathname.new(RSPEC_ROOT).join("example_project")
DatabaseTasks.db_dir = Pathname.new(DatabaseTasks.root).join("db")
DatabaseTasks.migrations_paths = [File.join(DatabaseTasks.root, 'db/migrate')]
DatabaseTasks.env = environment
DatabaseTasks.seed_loader = Seeder.new

task :environment do
  ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
  ActiveRecord::Base.establish_connection DatabaseTasks.env.to_sym
end

load 'active_record/railties/databases.rake'

DotenvRailsDbTasksFix.activate
