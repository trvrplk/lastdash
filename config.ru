require 'sinatra'
require 'haml'
require 'sass/plugin/rack'
require './dashboard'

Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack

run Sinatra::Application
