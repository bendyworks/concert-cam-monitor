require 'dashing'

require 'dotenv'
Dotenv.load

configure do
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application
