require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'dotenv'

require_relative "lib/dotenv_rails_db_tasks_fix"
require_relative "spec/support/active_record_tasks"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

RSPEC_ROOT = Pathname.new(File.dirname(__FILE__)).join("spec")
environment = ENV["RAILS_ENV"] || "development"
project_path = Pathname.new(RSPEC_ROOT).join("example_project")

Dotenv.overload(".env", ".env.#{environment}", ".env.local", ".env.#{environment}.local")
load_active_record_tasks(project_path: project_path, env: environment)

DotenvRailsDbTasksFix.activate
