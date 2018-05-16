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
require 'dotenv'
Dir[Pathname.new(RSPEC_ROOT).join("support", "**", "*.rb")].each { |f| require f }

environment = "development"
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

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
