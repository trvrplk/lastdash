require 'nokogiri'
require 'open-uri'

def get_recently_played(user, limit)
  Nokogiri::XML(URI.open("http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=#{user}&limit=#{limit}&api_key=3485d902c6ca1f6d1d440c1ffe64b7bd"))
end

def get_friends(user)
  Nokogiri::XML(URI.open("http://ws.audioscrobbler.com/2.0/?method=user.getfriends&user=#{user}&api_key=3485d902c6ca1f6d1d440c1ffe64b7bd"))
end

friends_doc = get_friends("kewlpinguino")
friends = friends_doc.xpath(".//user/name")
friends_listening = []


friends.each do |f|
  recent = get_recently_played(f.text, 1)
  if recent.xpath(".//track[@nowplaying='true']")
    song = f.xpath(".//track[@nowplaying='true']/name").text
    artist = f.xpath(".//track[@nowplaying='true']/artist").text
    album = f.xpath(".//track[@nowplaying='true']/album").text
    @art = f.xpath(".//track[@nowplaying='true']/image").text

    friends_listening.push("#{f.text}: #{song} by #{artist} from #{album}")
  end
end

friends_listening.each { |f| print f }