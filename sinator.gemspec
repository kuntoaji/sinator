require 'date'
require_relative 'lib/sinator/version'

Gem::Specification.new do |s|
  s.name        = 'sinator'
  s.version     = Sinator::VERSION
  s.date        = Date.today.to_s
  s.summary     = "Sinatra application boilerplate generator"
  s.description = "Sinator provides generator and contains minimal configuration to develop application with Sinatra"
  s.author      = 'Kunto Aji Kristianto'
  s.email       = 'kuntoaji@kaklabs.com'
  s.files       = `git ls-files -z`.split("\x0")
  s.executables << 'sinator'
  s.homepage    = 'http://github.com/kuntoaji/sinator'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.1'
  s.add_development_dependency 'bundler', '~> 1.7'
  s.add_development_dependency 'rspec', '3.2.0'
end
