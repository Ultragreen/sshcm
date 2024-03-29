# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'sshcm'
  spec.version       = `cat VERSION`.chomp
  spec.authors       = ['Romain GEORGES']
  spec.email         = ['romain@ultragreen.net']

  spec.summary       = 'SSH Configuration manager'
  spec.description   = 'SSH Configuration manager'
  spec.homepage      = 'https://github.com/Ultragreen/sshcm'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.0')

  spec.metadata['homepage_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'code_statistics', '~> 0.2.13'
  spec.add_development_dependency 'roodi', '~> 5.0'
  spec.add_development_dependency 'rubocop', '~> 1.32'
  spec.add_development_dependency 'yard', '~> 0.9.27'
  spec.add_development_dependency 'yard-rspec', '~> 0.1'

  spec.add_dependency 'carioca', '~> 2.0'
  spec.add_dependency 'secure_yaml', '~> 2.0'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
