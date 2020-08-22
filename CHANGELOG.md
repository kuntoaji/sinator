3.1.0:
  * update encrypted_cookie to version 0.1.0
  * set stdout and stderr puma on production

3.0.4:
  * update existing gems with non specific version
  * add sassc gem to generated app

3.0.3:
  * update gems

3.0.2:
  * replace APP_ENV with RACK_ENV

3.0.1:
  * update gems

3.0.0:
  * set explicit version to all required ruby gems
  * replace sinatra-asset-pipeline with sprockets
  * generate database.yml instead of database.yml.example
  * add rake tasks to perform assets:precompile and assets:clean
  * replace Thin web server with Puma web server
  * rename project to Sinator

2.0.1:
  * prevent sinatra-contrib to be required on Gemfile. Sinatra contrib is interfering with Rake’s own namespace support

2.0.0:
  * remove Melodiest::Application, only focus on application boilerplate

1.0.0:
  * prevent tux to be required
  * add sinatra assets pipeline extension
  * restructure generated app
  * use erb for app templates
  * create Rakefile generator with and without database
  * add new Sequel configuration when generating app with database
  * add Sinatra::Cache extension
  * remove Melodiest::Setting. Rename setup method to cookie_secret.
  * restructure generated app
  * add some configurations from h5bp

0.4.0:
  * add SQL logger to development environment
  * generate public dir when running generator
  * use tux as Sinatra console
  * when has no option, melodiest command will use --help option

0.3.0:
  * remove Melodiest::Auth::Http module, it's better to use sinatra-authorization extension
  * refactor Melodiest::Setting.setup so that it can be overridden via app and remove thin as dependency
  * add generator for sequel orm and postgres sql
  * use encrypted cookie
  * add generator for Rack::Csrf

0.2.x:
  * add sinatra application boilerplate generator
  * add melodiest command to run generator

0.1.x:
 * add http authorization module
 * set thin as server
