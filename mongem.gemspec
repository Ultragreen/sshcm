
Gem::Specification.new do |spec|
  spec.name          = "mongem"
  spec.version       = `cat VERSION`.chomp
  spec.authors       = ["Pierre Alphonse", "Camille Paquet"]
  spec.email         = ["pierre.alphonse@orange.com", "camille.paquet@orange.com"]

  spec.summary       = "Webservice endpoint mock provider"
  spec.description   = "Webservice endpoint mock provider"
  spec.homepage      = "https://github.com/Ultragreen/MockWS"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "roodi", "~> 5.0"
  spec.add_development_dependency 'code_statistics', '~> 0.2.13'
  spec.add_development_dependency "yard", "~> 0.9.27"
  spec.add_development_dependency "yard-rspec", "~> 0.1"
end
