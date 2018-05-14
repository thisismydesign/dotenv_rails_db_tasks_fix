require "bundler/setup"

RSPEC_ROOT = File.dirname __FILE__

def ran_by_guard
  ARGV.any? { |e| e =~ %r{guard-rspec} }
end

unless ran_by_guard
  require "simplecov"
  SimpleCov.add_filter %w[spec config]
  require "coveralls"
  Coveralls.wear!
end

require "dotenv_rails_db_tasks_fix"
require 'rake'
require 'yaml'
require 'dotenv'
require 'active_record'

environment = "development"
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

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
