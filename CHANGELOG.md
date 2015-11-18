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
