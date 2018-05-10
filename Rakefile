require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

require "active_record"
require "rails"

RSPEC_ROOT = Pathname.new(File.dirname(__FILE__)).join("spec")

include ActiveRecord::Tasks
DatabaseTasks.database_configuration = YAML.load_file(Pathname.new(RSPEC_ROOT).join("example_project", "config", "database.yml"))
DatabaseTasks.root = Pathname.new(RSPEC_ROOT).join("example_project")
DatabaseTasks.db_dir = 'db'
DatabaseTasks.migrations_paths = [File.join(DatabaseTasks.root, 'db/migrate')]
load 'active_record/railties/databases.rake'
