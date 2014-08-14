require 'faraday'
require 'json'

@album_id = ENV['ALBUM_ID']
raise "No Album Id" unless @album_id
ALBUM_URL = "https://graph.facebook.com/#{@album_id}"
ALBUM_PHOTOS_URL = "#{ALBUM_URL}/photos"

def get_album
  response = Faraday.get(ALBUM_PHOTOS_URL)

  JSON.parse(response.body)["data"]
end

def get_album_metadata
  response = Faraday.get(ALBUM_URL)
  fb_data = JSON.parse(response.body)
  album_title = fb_data["name"]
  more_info = fb_data["description"] + " Likes: " + fb_data["likes"]["data"].count.to_s
  count = fb_data["count"]

  {
    text: "Album ##{@album_id}",
    title: album_title,
    moreinfo: more_info,
    count: count
  }
end

def collect_by_minutes(photos, bucket_seconds)
  photos.reduce({}) do |memo, photo|
    minutes_since_epoch = Time.parse(photo["created_time"]).to_i / bucket_seconds

    presentable_time_since_epoch = minutes_since_epoch * bucket_seconds

    if memo.has_key? presentable_time_since_epoch
      memo[presentable_time_since_epoch] += 1
    else
      memo[presentable_time_since_epoch] = 1
    end
    memo
  end.map do |time, count|
    { x: time, y: count }
  end
end

def collect_five_minutes(album_photos)
  collect_by_minutes(album_photos, 300)
end

def collect_fifteen_minutes(album_photos)
  collect_by_minutes(album_photos, 900)
end

SCHEDULER.every '1m', first_in: 0 do
  metadata = get_album_metadata
  album_photos = get_album

  five_minute_points = collect_five_minutes(album_photos)
  fifteen_minute_points = collect_fifteen_minutes(album_photos)


  send_event('album_metadata', metadata)
  send_event('photo_count', current: metadata[:count], title: "Total # of photos uploaded")
  send_event('five_minutes', points: five_minute_points, title: "Five minute upload counts")
  send_event('fifteen_minutes', points: fifteen_minute_points, title: "Fifteen minute upload counts")
end
