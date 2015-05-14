require 'sequel'
require 'yaml'

env = ENV['RACK_ENV'] || 'development'

namespace :db do
  desc "Run migrations"
  task :migrate, [:version] do |t, args|
    Sequel.extension :migration
    db = Sequel.connect(YAML.load_file(File.expand_path("../config/database.yml", __FILE__))[env])
    migration_path = File.expand_path("../db/migrations", __FILE__)

    if args[:version]
      puts "Migrating to version #{args[:version]}"
      Sequel::Migrator.run(db, migration_path, target: args[:version].to_i)
    else
      puts "Migrating to latest"
      Sequel::Migrator.run(db, migration_path)
    end
  end
end
