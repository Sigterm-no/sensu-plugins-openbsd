lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'date'
require_relative 'lib/sensu-plugins-openbsd'

Gem::Specification.new do |s|
  s.authors                = ['Sensu-Plugins and contributors']
  s.date                   = Date.today.to_s
  s.description            = 'This plugin provides common checks for OpenBSD hosts'
  s.email                  = '<support@sigterm.no>'
  s.executables            = Dir.glob('bin/**/*.rb').map { |file| File.basename(file) }
  s.files                  = Dir.glob('{bin,lib}/**/*') + %w[CHANGELOG.md LICENSE README.md]
  s.homepage               = 'https://github.com/Sigterm-no/sensu-plugins-openbsd'
  s.license                = 'MIT'
  s.metadata               = { 'maintainer'         => '@mikalv',
                               'development_status' => 'active',
                               'production_status'  => 'unstable - testing recommended',
                               'release_draft'      => 'false',
                               'release_prerelease' => 'false' }
  s.name                   = 'sensu-plugins-openbsd'
  s.platform               = Gem::Platform::RUBY
  s.post_install_message   = 'Checks can be expected to find under /usr/local/bin, ensure the sensu user include it to PATH'
  s.require_paths          = ['lib']
  s.required_ruby_version  = '>= 2.0.0'
  s.summary                = 'Sensu plugins for OpenBSD'
  s.test_files             = s.files.grep(%r{^(test|spec|features)/})
  s.version                = SensuPluginsOpenBSD::Version::VER_STRING

  s.add_runtime_dependency 'english', '0.6.3'
  s.add_runtime_dependency 'sensu-plugin', '~> 2.7'

  s.add_development_dependency 'bundler',                   '~> 1.7'
  s.add_development_dependency 'codeclimate-test-reporter', '~> 0.4'
  s.add_development_dependency 'github-markup',             '~> 1.3'
  s.add_development_dependency 'pry',                       '~> 0.12'
  s.add_development_dependency 'rake',                      '~> 10.5'
  s.add_development_dependency 'redcarpet',                 '~> 3.2'
  s.add_development_dependency 'rspec',                     '~> 3.4'
  s.add_development_dependency 'rubocop',                   '~> 0.51.0'
  s.add_development_dependency 'yard',                      '~> 0.9.11'
end
