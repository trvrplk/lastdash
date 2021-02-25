require 'sinatra'
require 'haml'
require 'sass/plugin/rack'
require './dashboard'

Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack

if memcache_servers = ENV["MEMCACHE_SERVERS"]
  use Rack::Cache,
    verbose: true,
    metastore:   "memcached://#{memcache_servers}",
    entitystore: "memcached://#{memcache_servers}"
end

run Sinatra::Application
