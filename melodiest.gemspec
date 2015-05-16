require_relative 'lib/melodiest/version'

Gem::Specification.new do |s|
  s.name        = 'melodiest'
  s.version     = Melodiest::VERSION
  s.date        = Date.today.to_s
  s.summary     = "Sinatra application boilerplate"
  s.description = "Melodiest provides generator and useful modules for your Sinatra application"
  s.author      = 'Kunto Aji Kristianto'
  s.email       = 'kunto.aji.kr@slackware-id.org'
  s.files       = `git ls-files -z`.split("\x0")
  s.executables << 'melodiest'
  s.homepage    = 'http://github.com/kuntoaji/melodiest'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.1'
  s.add_development_dependency 'bundler', '~> 1.7'
  s.add_development_dependency 'rspec', '3.2.0'
  s.add_development_dependency 'rack-test', '0.6.3'
  s.add_development_dependency 'fakefs', '0.6.7'
  s.add_runtime_dependency 'sinatra', '1.4.6'
  s.add_runtime_dependency 'sinatra-contrib', '1.4.2'
  s.add_runtime_dependency 'encrypted_cookie', '0.0.4'
end
