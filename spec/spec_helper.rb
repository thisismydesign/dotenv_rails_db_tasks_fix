require "bundler/setup"
require "dotenv_rails_db_tasks_fix"
require "active_record"
require 'rake'

RSPEC_ROOT = File.dirname __FILE__

include ActiveRecord::Tasks
DatabaseTasks.database_configuration = YAML.load_file(Pathname.new(RSPEC_ROOT).join("example_project", "config", "database.yml"))
DatabaseTasks.root = Pathname.new(RSPEC_ROOT).join("example_project")
DatabaseTasks.db_dir = 'db'
DatabaseTasks.migrations_paths = [File.join(DatabaseTasks.root, 'db/migrate')]

load 'active_record/railties/databases.rake'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
