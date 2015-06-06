development:
  * add SQL logger to development environment
  * generate public dir when running generator

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
