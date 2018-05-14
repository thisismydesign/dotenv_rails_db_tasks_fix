require "yaml"
require "active_record"
require "erb"

class Seeder
  def initialize(seed_file)
    @seed_file = seed_file
  end

  def load_seed
    load @seed_file unless File.file?(@seed_file)
  end
end

# Assumes Rails default structure
def load_active_record_tasks(project_path:, env:)
  db_config = project_path.join("config", "database.yml")

  include ActiveRecord::Tasks
  DatabaseTasks.database_configuration = YAML::load(ERB.new(File.read(db_config)).result)
  DatabaseTasks.root = project_path
  DatabaseTasks.db_dir = Pathname.new(DatabaseTasks.root).join("db")
  DatabaseTasks.migrations_paths = [File.join(DatabaseTasks.root, 'db/migrate')]
  DatabaseTasks.env = env
  DatabaseTasks.seed_loader = Seeder.new(File.join(DatabaseTasks.root, 'db/seeds.rb'))

  task :environment do
    ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
    ActiveRecord::Base.establish_connection DatabaseTasks.env.to_sym
  end

  load 'active_record/railties/databases.rake'
end
