# Melodiest

Melodiest is [Sinatra](http://www.sinatrarb.com/) configuration boilerplate. The purpose of this gem is because I'm too lazy to write configuration every my Sinatra project.

### Installation


```ruby
gem install melodiest
```

with Bundler, put this code in your Gemfile:

```ruby
gem 'melodiest'
```

### How to Use
#### Command
generate app in current directory
```
melodiest -n my_app
```
generate app in target directory
```
melodiest -n my_app -d target/dir
```

#### Example Code
Because Melodiest is already required Sinatra, you don't have to require 'sinatra' anymore, just require 'melodiest'.

`Melodiest::Application` is subclass from `Sinatra::Application` and by default is using configuration from `Melodiest::Setting.setup` method.


```ruby
# my_app.rb

require 'melodiest/auth/http'

class App < Melodiest::Application'
  configure do
    # Load up database and such
  end
  
  helpers Melodiest::Auth::Http
end

# app/routes/my_routes.rb

get "/" do
  "hello world!"
end

get "/protected" do
  authorized! "myhttpauthusername", "myhttpauthpassword"
  "welcome!"
end

```
#### Run the server
```
bundle exec rackup
```


### Configuration

See [melodiest/config.yml](https://github.com/kuntoaji/melodiest/blob/master/lib/melodiest/config.yml)

### Helpers

Helper methods

  * `Melodiest::Auth::Http`
