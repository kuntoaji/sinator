%w{/app/models /app/helpers /app/routes}.each do |dir|
  resource_dir = Melodiest::ROOT + dir

  Dir[File.join(resource_dir, '**/*.rb')].each do |file|
    require file
  end
end
