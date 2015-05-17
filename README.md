# Melodiest

Melodiest is [Sinatra](http://www.sinatrarb.com/) application boilerplate. It provides generator and contains minimalist configuration to develop application with Sinatra.

### Installation

```ruby
gem install melodiest
```

with Bundler, put this code in your Gemfile:

```ruby
gem 'melodiest'
```

### How to Use
generate app in current directory without database

```
melodiest -n my_app
```

generate app in target directory without database

```
melodiest -n my_app -t target/dir
```

generate app in current directory with database. `-d` option will generate app with `Sequel` orm and PostgreSQL adapter.

```
melodiest -n my_app -d
```

### Melodiest::Application
Because Melodiest is already required Sinatra, you don't have to require 'sinatra' anymore, just require 'melodiest'.

`Melodiest::Application` is subclass from `Sinatra::Application` and by default is using configuration from `Melodiest::Setting.setup` method.

```ruby
# my_app.rb

class App < Melodiest::Application
  setup 'this_is_secret_for_encrypted_cookie'
  ...
end
```

### Example Usage
This example assume that PostgreSQL is already running and desired database is already exist.
  1. run `melodiest -n my_app -d`
  2. cd `my_app`
  3. run `bundle install`
  4. create `config/database.yml` and configure your database setting
  5. create file `db/migrations/001_create_artists.rb` and put the following code:
  
  ```ruby
  Sequel.migration do
    up do
      create_table(:artists) do
        primary_key :id
        String :name, :null=>false
      end
    end
  
    down do
      drop_table(:artists)
    end
  end
  ```
  
  6. run `rake db:migrate`
  7. create file `app/models/Artist.rb` and put the following code:
  
  ```ruby
  class Artist < Sequel::Model
  end
  ```
  
  8. create file `app/routes/artists.rb` and put the following code:
  
  ```ruby
  class MyApp
    get '/' do
      "hello world!"
    end

    get '/artists' do
      # for example purpose :)
      artist = Artist.new
      artist.name = 'Melody'
      artist.save
    
      @artists = Artist.all
      erb :"artists/index"
    end
  end
  ```
  
  9. create file `app/views/artists/index.erb` and put the following code:
  
  ```
  <h1>List of Artist</h1>
  <% @artists.each do |artist| %>
    <li><%= artist.name %></li>
  <% end %>
  ```
  
  10. run the server `bundle exec rackup`
  11. open url `localhost:9292/artists`

### Default Configuration

  * `Sinatra::Reloader` in development environment only
  * `Rack::Session::EncryptedCookie`
  * `Rack::Csrf`
  * `Sequel` ORM
  * `sequel_pg` as PostgreSQL adapter
