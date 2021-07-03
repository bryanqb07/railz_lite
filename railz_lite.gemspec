# frozen_string_literal: true

require_relative "lib/railz_lite/version"

Gem::Specification.new do |spec|
  spec.name          = "railz_lite"
  spec.version       = RailzLite::VERSION
  spec.authors       = ["bryan lynch"]
  spec.email         = ["bml312@nyu.edu"]

  spec.summary       = "Simple, bare-bones web app template inspired by Rails."
  spec.homepage      = "https://github.com/bryanqb07/my_rails"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org/"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/bryanqb07/my_rails"
  spec.metadata["changelog_uri"] = "https://github.com/bryanqb07/my_rails"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "rack", '~> 2.2.3'
  spec.add_dependency "activesupport", '~> 6.1.4'
  spec.add_dependency "puma", '~> 5.3.2'
  spec.add_dependency "sqlite3", '~> 1.4.2'
  spec.add_dependency "thor", '~> 1.1.0'
  spec.add_dependency "loofah", '~> 2.10.0'


  spec.add_development_dependency "byebug"
  spec.add_development_dependency 'rspec', '~> 3.1.0'
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", "~> 1.7"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
