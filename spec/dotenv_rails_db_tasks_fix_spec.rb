RSpec.describe DotenvRailsDbTasksFix do
  it "has a version number" do
    expect(DotenvRailsDbTasksFix::VERSION).not_to be nil
  end

  describe "rake db:create" do
    after do
      FileUtils.rm(Pathname.new(RSPEC_ROOT).join("example_project", "db", "development.sqlite3"))
      FileUtils.rm(Pathname.new(RSPEC_ROOT).join("example_project", "db", "test.sqlite3"))
    end

    it "outputs DB creation message for 'development' and 'test' DBs" do
      output = "Created database 'spec/example_project/db/development.sqlite3'\nCreated database 'spec/example_project/db/test.sqlite3'\n"
      expect { Rake::Task["db:create"].invoke }.to output(output).to_stdout
    end
  end
end
