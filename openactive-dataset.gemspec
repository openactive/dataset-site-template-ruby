lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "openactive/dataset/version"

Gem::Specification.new do |spec|
  spec.name          = "openactive-dataset"
  spec.version       = OpenActive::Dataset::VERSION
  spec.authors       = ["OpenActive Community"]
  spec.email         = ["hello@openactive.io"]

  spec.summary       = 'Write a short summary, because RubyGems requires one.'
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://openactive.io"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "mustache"
  spec.add_runtime_dependency "openactive"
  spec.add_runtime_dependency "typesafe_enum"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-rspec"
end
