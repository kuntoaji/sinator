# Melodiest

Melodiest is [Sinatra](http://www.sinatrarb.com/) application boilerplate. It provides generator and useful modules for developing application.

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

class App < Melodiest::Application
  configure do
    # Load up database and such
  end
end

# app/routes/my_routes.rb

get "/" do
  "hello world!"
end

```
#### Run the server
```
bundle exec rackup
```


### Default Configuration

  * `Sinatra::Reloader` in development environment only
  * See [melodiest/config.yml](https://github.com/kuntoaji/melodiest/blob/master/lib/melodiest/config.yml)
