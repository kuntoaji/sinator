# http://sequel.jeremyevans.net/rdoc/files/doc/migration_rdoc.html

# Sequel.migration do
#   up do
#     add_column :artists, :location, String
#     from(:artists).update(:location=>'Sacramento')
#   end
#
#   down do
#     drop_column :artists, :location
#   end
# end
