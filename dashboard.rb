require 'sinatra'
require 'open-uri'
require 'nori'



set :haml, :format => :html5

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
  haml :you_dashboard, :locals => {:tracks => tracks, :user => "#{params[:user]}"} 
end

get '/all/:user' do
  friends = get_friends("#{params[:user]}")["lfm"]["friends"]["user"]
  haml :all_dashboard, :locals => {:friends => friends}
end
