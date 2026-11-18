# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Sinator is a Ruby gem and CLI (`sinator`) that generates a Sinatra application skeleton, optionally with PostgreSQL + Sequel ORM (`-d`). Requires Ruby >= 3.3.1.

## Commands

- Install deps: `bundle install`
- Run all tests: `bundle exec rspec`
- Run one file: `bundle exec rspec spec/sinator/generator_spec.rb`
- Run one example: `bundle exec rspec spec/sinator/generator_spec.rb:<line>`
- Run the CLI locally: `ruby -Ilib bin/sinator -n my_app [-t target/dir] [-d]`
- Build the gem: `gem build sinator.gemspec`

There is no Rakefile or linter in this repo. The gemspec uses `git ls-files` for its file list, so new files must be tracked in git to ship in the gem.

## Architecture

- `bin/sinator` -> `Sinator::Command.parse(ARGV)` (`lib/sinator/command.rb`): OptionParser handles `-n/--name`, `-t/--target`, `-d/--database`, `-v`, `-h`. With a name, `Command.run` calls the generator steps in order: `generate_app`, `generate_rakefile`, `generate_gemfile`, `generate_bundle_config`, `generate_puma_config`.
- `Sinator::Generator` (`lib/sinator/generator.rb`) works in two ways on `lib/sinator/templates/`:
  - Static files (`assets`, `config`, `public`, `app`, and `db` only with `-d`) are copied as-is by `copy_templates`. Without `-d`, `config/database.yml` is deleted after copying.
  - `*.erb` templates (`app.erb`, `Rakefile.erb`, `Gemfile.erb`, `config.ru.erb`, `app/routes/home.erb`, `config/puma/*.erb`) render with the generator's `binding`, so they read `@app_name`, `@app_class_name` (CamelCase of the snake_case name), and `@with_database`. Copied `.erb` sources are removed after rendering.
  - Note: `app/views/*.erb` are Sinatra views for the generated app, not generator templates. They are copied verbatim.
- The generated app is a modular Sinatra app: `<app_name>.rb` defines the app class, routes go in `app/routes/*.rb` by reopening that class, and it runs with `bundle exec puma`.

## Tests

- Specs generate real apps into `/tmp/sinator` and `/tmp/sinator_with_db`, and delete them before and after each example.
- Rendered ERB output is compared byte-for-byte against `spec/fixtures/` (`with_db/` and `without_db/` variants) through `Helper::Generator#expect_file_eq` in `spec/helpers/generator.rb`. When you change an ERB template, update the matching fixture.
