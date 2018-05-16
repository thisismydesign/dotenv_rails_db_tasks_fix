RSpec.describe DotenvRailsDbTasksFix do
  def remove_db_files
    Dir.glob(Pathname.new(".").join("file:*\?mode=memory")) { |file| FileUtils.rm(file) }
  end

  before do
    remove_db_files
  end

  after do
    remove_db_files
  end

  it "has a version number" do
    expect(DotenvRailsDbTasksFix::VERSION).not_to be nil
  end

  describe "the problem" do
    describe "db:create" do
      skip "tries to create 'development' DB twice" do
      end
    end
  end

  describe "the solution" do
    before :all do
      # HEADS UP! Order of tests cannot be random because of this.
      DotenvRailsDbTasksFix.activate
    end

    describe ".activate" do
      context "when not in development environment" do
        before do
          DatabaseTasks.env = "test"
        end
  
        after do
          DatabaseTasks.env = "development"
        end
  
        it "raises error" do
          expect { DotenvRailsDbTasksFix.activate }.to raise_error(/activated outside of development environment/)
        end
      end
    end
  
    describe "rake tasks" do
      describe "db:create" do
        it "outputs DB creation message for 'development' and 'test' DBs" do
          output = "Created database 'file:mem_db_development?mode=memory'\nCreated database 'file:mem_db_test?mode=memory'\n"
          expect { Rake::Task["db:create"].invoke }.to output(output).to_stdout
        end
      end
  
      describe "db:setup" do
        skip "outputs DB creation message for 'development' and 'test' DBs" do
          # TODO: figure out why db:drop doesn't work
          # OR reinitialize DB between tests
          output = "Created database 'file:mem_db_development?mode=memory'\nCreated database 'file:mem_db_test?mode=memory'\n"
          expect { Rake::Task["db:setup"].invoke }.to output(output).to_stdout
        end
      end
    end
  end
end
