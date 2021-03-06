require 'sinatra'
require 'sinatra/partial'
require 'open-uri'
require 'nori'

require 'dalli'
require 'rack-cache'

configure do
  set :sass, {:style => :compressed, :debug_info => false}
  set :haml, :format => :html5
  set :static_cache_control, [:public, :max_age => 120]
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
  Nori.new.parse(URI.open("http://ws.audioscrobbler.com/2.0/?method=user.getfriends&user=#{user}&api_key=#{$api_key}&format=xml").read)
end

def get_info(user)
  Nori.new.parse(URI.open("http://ws.audioscrobbler.com/2.0/?method=user.getinfo&user=#{user}&api_key=#{$api_key}&format=xml").read)
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
  cache_control :public, max_age: 120
  
  @tracks = get_recently_played("#{params[:user]}", 6)["lfm"]["recenttracks"]["track"] 
  # Check if user is currently scrobbling or not
  if @tracks[0]["@nowplaying"]
    @your_track = @tracks[0]
    @last_five = @tracks[1..5]
  else
    @last_five = @tracks[0..5]
  end
  
  friends = get_friends("#{params[:user]}")["lfm"]["friends"]["user"]
  your_avatar = get_info("#{params[:user]}")["lfm"]["user"]["image"][1]

  if friends.class == Array
    @online_friends = []
    friends.each do |f|
      tracks = get_recently_played(f["name"], 1)["lfm"]["recenttracks"]["track"]
      
      if tracks.class == Array
        @online_friends << [f, tracks[0]]
      end
      rescue OpenURI::HTTPError => e
        puts "Skipping, #{e.message}"
        next
    end
  end


  haml :all_dashboard, :layout => :default_layout, :locals => {:user => "#{params[:user]}", :your_track => @your_track, :friends => @online_friends, :last_five => @last_five, :your_avatar => your_avatar}
end
