require 'net/http'
require 'uri'
require 'nokogiri'
require 'htmlentities'

news_feeds = {
  "bendyworks-blog" => "http://bendyworks.com/geekville.atom",
}

Decoder = HTMLEntities.new

class News
  def initialize(widget_id, feed)
    @widget_id = widget_id
    # pick apart feed into domain and path
    uri = URI.parse(feed)
    @path = uri.path
    @http = Net::HTTP.new(uri.host)
  end

  def widget_id()
    @widget_id
  end

  def latest_headlines()
    response = @http.request(Net::HTTP::Get.new(@path))
    doc = Nokogiri::XML(response.body).children.first

    news_headlines = [];
    doc.css('entry').each do |news_item|
      title = clean_html( news_item.css('title').text )
      description = clean_html( news_item.css('content').text ).slice(0, 256)
      author = clean_html( news_item.css('author').text )
      news_headlines.push({ title: title, description: description, author: author })
    end

    news_headlines
  end

  def clean_html( html )
    html = html.gsub(/<\/?[^>]*>/, "")
    html = Decoder.decode( html )
    return html
  end

end

@News = []
news_feeds.each do |widget_id, feed|
  begin
    @News.push(News.new(widget_id, feed))
  rescue Exception => e
    puts e.to_s
  end
end

SCHEDULER.every '60m', :first_in => 0 do |job|
  @News.each do |news|
    headlines = news.latest_headlines()
    send_event(news.widget_id, { :headlines => headlines })
  end
end
