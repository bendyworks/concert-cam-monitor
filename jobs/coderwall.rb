require 'net/http'
require 'json'

require 'dotenv'
Dotenv.load

SCHEDULER.every '30m', :first_in => '5s' do |job|
  uri = URI.parse("https://coderwall.com/team/#{ENV['CODERWALL_TEAM']}.json")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(request)
  status = JSON.parse(response.body)

  name = status['name'].to_s
  rank = status['rank'].to_s
  team_size = status['size'].to_s
  moreinfo = name + ", currently at " + team_size.to_s + " members."

  send_event("coderwall", { title: "Coderwall Rank", current: rank, moreinfo: moreinfo })
end
