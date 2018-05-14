require "dotenv_rails_db_tasks_fix/version"
require "dotenv"
require "active_record"

module DotenvRailsDbTasksFix
  def self.activate
    ActiveRecord::Tasks::DatabaseTasks.instance_eval do
      return unless env.eql?("development")

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
          yield config[environment], environment if config[environment]["database"]
        end
      end
    end
  end
end
