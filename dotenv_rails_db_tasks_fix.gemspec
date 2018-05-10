lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dotenv_rails_db_tasks_fix/version"

Gem::Specification.new do |spec|
  spec.name          = "dotenv_rails_db_tasks_fix"
  spec.version       = DotenvRailsDbTasksFix::VERSION
  spec.authors       = ["thisismydesign"]
  spec.email         = ["git.thisismydesign@gmail.com"]

  spec.summary       = ""
  spec.homepage      = ""

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dotenv"
  spec.add_dependency "rails", ">= 5.1.5", "~> 5.1.6" # Because of `Rails.env`, otherwise activerecord would be enough

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
