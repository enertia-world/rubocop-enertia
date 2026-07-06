# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = 'rubocop-enertia'
  spec.version = '0.1.0'
  spec.authors = ['Enertia World']
  spec.email = ['junaid@enertia.world']
  spec.license = 'MIT'
  spec.homepage = 'https://github.com/enertia-world/rubocop-enertia'

  spec.summary = 'Omakase Ruby styling for Enertia projects'
  spec.description = 'Shared RuboCop configuration for Enertia Rails apps and gems, distributed via inherit_gem.'
  spec.required_ruby_version = '>= 3.2.0'

  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.metadata['github_repo'] = 'enertia-world/rubocop-enertia'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  spec.files = Dir['lib/**/*', '*.yml', 'README.md', 'LICENSE']
  spec.require_paths = ['lib']

  spec.add_dependency 'rubocop', '~> 1.88'
  spec.add_dependency 'rubocop-capybara', '~> 3.0'
  spec.add_dependency 'rubocop-factory_bot', '~> 2.28'
  spec.add_dependency 'rubocop-rails', '~> 2.35'
  spec.add_dependency 'rubocop-rspec', '~> 3.10'
end
