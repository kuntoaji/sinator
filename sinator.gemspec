require 'date'
require_relative 'lib/sinator/version'

Gem::Specification.new do |s|
  s.name        = 'sinator'
  s.version     = Sinator::VERSION
  s.date        = Date.today.to_s
  s.summary     = 'Sinatra application generator'
  s.description = 'Sinator will generate Sinatra application with minimum configuration'
  s.author      = 'Kunto Aji Kristianto'
  s.email       = 'kuntoaji@kaklabs.com'
  s.files       = `git ls-files -z`.split("\x0")
  s.executables << 'sinator'
  s.homepage    = 'http://github.com/kuntoaji/sinator'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 3.3.1'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov'
end
