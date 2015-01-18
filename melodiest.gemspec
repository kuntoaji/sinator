require_relative 'lib/melodiest/version'

Gem::Specification.new do |s|
  s.name        = 'melodiest'
  s.version     = Melodiest::VERSION
  s.date        = '2014-12-29'
  s.summary     = "Sinatra configuration boilerplate"
  s.description = "Sinatra configuration boilerplate"
  s.author      = 'Kunto Aji Kristianto'
  s.email       = 'kunto.aji.kr@slackware-id.org'
  s.files       = ["lib/melodiest.rb"]
  s.homepage    = 'http://github.com/kuntoaji/melodiest'
  s.license     = 'MIT'

  s.add_development_dependency 'bundler', '~> 1.7'
  s.add_development_dependency 'rspec', '3.1.0'
  s.add_runtime_dependency 'sinatra', '1.4.5'
  s.add_runtime_dependency 'thin', '1.6.3'
end
