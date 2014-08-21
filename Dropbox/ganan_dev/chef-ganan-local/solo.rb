base = File.expand_path('..', __FILE__)
file_cache_path "/tmp/chef-solo"
cookbook_path ["#{base}/site-cookbooks", "#{base}/cookbooks"]
ssl_verify_mode :verify_peer
