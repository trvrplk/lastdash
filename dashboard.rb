require 'sinatra'
require 'sinatra/partial'
require 'open-uri'
require 'nori'
require 'redis'

configure do
  set :scss, {:style => :compressed, :debug_info => false}
  set :haml, :format => :html5
end

get '/css/:name.css' do |name|
  content_type :css
  sass "sass/#{name}".to_sym, :layout => false
end

$keys = YAML.load_file("lastfm.yml")
$api_key = $keys[:api_key]

def get_recently_played(user, limit)
  Nori.new.parse(URI.open("http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=#{user}&limit=#{limit}&api_key=#{$api_key}&format=xml").read)
end

def get_friends(user)
  Nori.new.parse(URI.open("http://ws.audioscrobbler.com/2.0/?method=user.getfriends&user=#{user}&api_key=#{
  $api_key}&format=xml").read)
end

get '/you/:user' do
  tracks = get_recently_played("#{params[:user]}", 10)["lfm"]["recenttracks"]["track"]
  haml :you_dashboard,  :layout => :default_layout, :locals => {:tracks => tracks, :user => "#{params[:user]}"} 
end

get '/friends/:user' do
  friends = get_friends("#{params[:user]}")["lfm"]["friends"]["user"]
  haml :friends_dashboard, :layout => :default_layout, :locals => {:friends => friends}
end

get '/all/:user' do
  get_recently_played("#{params[:user]}", 1)["lfm"]["recenttracks"]["track"] do |track|
    if track.class == Array
      @your_track = track
    end
  end

  friends = get_friends("#{params[:user]}")["lfm"]["friends"]["user"]
  haml :all_dashboard, :layout => :default_layout, :locals => {:your_track => @your_track, :friends => friends}
end
