source 'https://rubygems.org'

gem 'melodiest', '1.0.0'
gem 'thin'
gem 'tux', require: false
gem 'sinatra-asset-pipeline', require: 'sinatra/asset_pipeline'
gem 'uglifier', require: false
gem 'rack_csrf', require: 'rack/csrf'
gem 'sequel'
gem 'sequel_pg', require: 'sequel'

group :production do
  gem 'sinatra-cache'
end
