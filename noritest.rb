require "nori"
require "open-uri"

def get_recently_played(user, limit)
  Nori.new.parse(URI.open("http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=#{user}&limit=#{limit}&api_key=3485d902c6ca1f6d1d440c1ffe64b7bd").read)
end


def get_friends(user)
  Nori.new.parse(URI.open("http://ws.audioscrobbler.com/2.0/?method=user.getfriends&user=#{user}&api_key=3485d902c6ca1f6d1d440c1ffe64b7bd&format=xml").read)
end

friends = get_friends('kewlpinguino')["lfm"]["friends"]["user"]


# friends.each do |f|
#   # pp t
#   # puts track.dig "lfm" "recenttracks" "track" "name"
#   # puts "#{f["name"]} by #{t["artist"]} from #{t["album"]}"
#   # pp f
#   puts f["name"]
# end

friends.each do |f|
  tracks = get_recently_played(f["name"], 1)["lfm"]["recenttracks"]["track"]
  
  # Only show if now playing -- it will be an array of two songs if the user is playing, because for some reason it lists the song twice, once without the attribute. It's more efficient to just see if it's an array than to loop the array to find if it's now playing, since it has to be, otherwise it wouldn't be an array
  if tracks.class == Array
    t = tracks[1]
    puts "#{f['name']}: #{t['name']} by #{t['artist']} from #{t['album']}"
    #
    # To include users not currently playing:
    # else
    # puts "#{f['name']}: #{tracks['name']} by #{tracks['artist']} from #{tracks['album']}"
  end
end