# Background

Sinator is [Sinatra](http://www.sinatrarb.com/) application generator. It will generate Sinatra web application with minimum configuration.
The reasons behind this project because I want to create many small web application based on sinatra with other third party ruby gems as foundation.

# Features
* Generate Sinatra based web application without database
* Generate Sinatra based web application with PostgreSQL database configuration and Sequel as ORM
* Rake task for assets precompile and assets clean

### Installation

```ruby
gem install sinator
```

with Bundler, put this code in your Gemfile:

```ruby
gem 'sinator'
```

### How to Use
generate app in current directory without database

```
sinator -n my_app
```

generate app in target directory without database

```
sinator -n my_app -t target/dir
```

generate app in current directory with database. `-d` option will generate app with `Sequel` ORM and PostgreSQL adapter.

```
sinator -n my_app -d
```

### Example Usage
This example assume that PostgreSQL is already running and desired database is already exist.
For complete example see [github.com/kuntoaji/todo_sinator](https://github.com/kuntoaji/todo_sinator)
  1. run `sinator -n my_app -d`
  2. cd `my_app`
  3. run `bundle install`
  4. configure your database setting in `config/database.yml`
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
    get '/artists' do
      @artists = Artist.all
      erb :"artists/index"
    end

    post '/artists' do
      @artist = Artist.new
      @artist.name = params[:name]
      @artist.save

      redirect '/artists'
    end
  end
  ```

  9. create file `app/views/artists/index.erb` and put the following code:

  ```erb
  <h1>List of Artist</h1>
  <ul>
    <% @artists.each do |artist| %>
      <li><%= artist.name %></li>
    <% end %>
  </ul>

  <form action="/artists" method="post">
    <%= Rack::Csrf.tag(env) %>
    <input type="text" name="name" />
    <button>Submit</button>
  </form>
  ```

  10. run the server `bundle exec puma`
  11. open url `localhost:9292/artists`

### List of Ruby Gems

  * sinatra
  * sinatra-contrib
  * encrypted_cookie
  * `Sinatra::Reloader` in development environment only
  * puma
  * `Rack::Session::EncryptedCookie`
  * `Rack::Csrf`
  * sequel
  * sequel_pg as PostgreSQL adapter
  * sprockets
  * sass
  * uglifier
  * tux for console, run with `bundle exec tux`
