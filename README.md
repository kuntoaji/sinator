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
melodiest my_app
```
generate app in target directory
```
melodiest my_app target/dir
```

#### Example Code
Because Melodiest is already required Sinatra, you don't have to require 'sinatra' anymore, just require 'melodiest'.

`Melodiest::Application` is subclass from `Sinatra::Application` and by default is using configuration from `Melodiest::Setting.setup` method.


```ruby
# mysinatraapp.rb

require 'melodiest'
require 'melodiest/auth/http'

class App < Melodiest::Application
  helpers Melodiest::Auth::Http

  get "/" do
    "hello world!"
  end

  get "/protected" do
    authorized! "myhttpauthusername", "myhttpauthpassword"
  end

end

```

#### Configuration

Configuration

  * `set :server, 'thin'`

#### Helpers

Helper methods

  * `Melodiest::Auth::Http`
