require 'dashing'

require 'dotenv'
Dotenv.load

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application
