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

Dotenv.overload(".env", ".env.#{environment}", ".env.local", ".env.#{environment}.local")
load_active_record_tasks(project_path: project_path, env: environment)

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
