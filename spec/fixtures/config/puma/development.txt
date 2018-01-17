threads 4, 4
workers 2
preload_app!

before_fork do
  MyApp::DB.disconnect if defined?(MyApp::DB)
end