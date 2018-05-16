require "active_record"

def load_active_record_tasks(database_configuration:, root:, db_dir: root, migrations_paths: [root], env: "development", seed_loader: nil)
  include ActiveRecord::Tasks
  DatabaseTasks.database_configuration = database_configuration
  DatabaseTasks.root = root
  DatabaseTasks.db_dir = db_dir
  DatabaseTasks.migrations_paths = migrations_paths
  DatabaseTasks.env = env
  DatabaseTasks.seed_loader = seed_loader

  task :environment do
    ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
    ActiveRecord::Base.establish_connection DatabaseTasks.env.to_sym
  end

  load 'active_record/railties/databases.rake'
end
