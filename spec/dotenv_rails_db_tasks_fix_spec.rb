
RSpec.describe DotenvRailsDbTasksFix do
  it "has a version number" do
    expect(DotenvRailsDbTasksFix::VERSION).not_to be nil
  end

  describe "rake tasks" do
    def remove_db_files
      Dir.glob(Pathname.new(RSPEC_ROOT).join("example_project", "db", "*.sqlite3")) { |file| FileUtils.rm(file) }
    end

    before do
      remove_db_files
    end

    after do
      remove_db_files
    end

    describe "db:create" do
      it "outputs DB creation message for 'development' and 'test' DBs" do
        output = "Created database 'spec/example_project/db/development.sqlite3'\nCreated database 'spec/example_project/db/test.sqlite3'\n"
        expect { Rake::Task["db:create"].invoke }.to output(output).to_stdout
      end
    end

    describe "db:reset" do
      it "outputs error message about 'development' and 'test' DBs not existing" do
        error_output = "Database 'spec/example_project/db/development.sqlite3' does not exist\nDatabase 'spec/example_project/db/test.sqlite3' does not exist\n"
        expect { Rake::Task["db:reset"].invoke }.to output(error_output).to_stderr
      end
    end
  end
end
