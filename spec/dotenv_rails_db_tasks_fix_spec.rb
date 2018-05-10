RSpec.describe DotenvRailsDbTasksFix do
  it "has a version number" do
    expect(DotenvRailsDbTasksFix::VERSION).not_to be nil
  end

  it "can execute `rake db:create`" do
    Rake::Task["db:create"].invoke
  end
end
