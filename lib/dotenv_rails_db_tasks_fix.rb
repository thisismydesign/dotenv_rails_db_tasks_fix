require "dotenv_rails_db_tasks_fix/version"
require "dotenv"
require "active_record"

module DotenvRailsDbTasksFix
  def self.activate
    target_env = "development".freeze
    raise "`DotenvRailsDbTasksFix` activated outside of #{target_env} environment" unless ActiveRecord::Tasks::DatabaseTasks.env.eql?(target_env)

    ActiveRecord::Tasks::DatabaseTasks.instance_eval do
      private

      def each_current_configuration(environment)
        environments = [environment]
        environments << "test" if environment == "development"

        environments.each do |environment|
          # On load order see: https://github.com/bkeepers/dotenv#what-other-env-files-can-i-use
          if environment.eql?("test")
            Dotenv.overload(".env", ".env.#{environment}", ".env.#{environment}.local")
          else
            Dotenv.overload(".env", ".env.#{environment}", ".env.local", ".env.#{environment}.local")
          end

          # This is a fix for consecutive `db:setup` calls
          # Without this they would run into `ActiveRecord::EnvironmentMismatchError`
          # Otherwise it could be circumvented by using the `DISABLE_DATABASE_ENVIRONMENT_CHECK` env var or executing `db:drop` previously
          # Check for `Rails` is there because it's not a dependency
          Rails.env = environment if defined?(Rails)

          db_config = Pathname.new(self.root).join("config", "database.yml")
          config = YAML::load(ERB.new(File.read(db_config)).result)

          active_record_version = Gem::Version.new(ActiveRecord.version)

          if active_record_version < Gem::Version.new("5.1.5")
            # https://github.com/rails/rails/blob/v5.1.0/activerecord/lib/active_record/tasks/database_tasks.rb#L298-L306
            yield config[environment] if config[environment]["database"]
          else
            # https://github.com/rails/rails/blob/v5.1.5/activerecord/lib/active_record/tasks/database_tasks.rb#L298-L307
            yield config[environment], environment if config[environment]["database"]
          end
        end
      end
    end
  end
end
