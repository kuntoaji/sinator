require_relative 'lib/melodiest/version'

Gem::Specification.new do |s|
  s.name        = 'melodiest'
  s.version     = Melodiest::VERSION
  s.date        = '2014-12-20'
  s.summary     = "Sinatra configuration boilerplate"
  s.description = "Sinatra configuration boilerpalte"
  s.authors     = ["Kunto Aji Kristianto"]
  s.email       = 'kunto.aji.kr@slackware-id.org'
  s.files       = ["lib/melodiest.rb"]
  s.homepage    = 'http://github.com/kuntoaji/melodiest'
  s.license     = 'MIT'

  s.add_runtime_dependency 'sinatra', '1.4.5'
  s.requirements << 'sinatra, v1.4.5'
end
