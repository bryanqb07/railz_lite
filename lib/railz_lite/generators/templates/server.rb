require 'rack'
require 'railz_lite/controllers/static'
require 'railz_lite/controllers/show_exceptions'
require 'railz_lite/controllers/router'

router = Router.new
router.draw do
  # add routes here
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

app = Rack::Builder.new do
  use ShowExceptions # generates helpful error messages
  use Static # serves static assets from /public
  run app
end.to_app

Rack::Server.start(
 app: app,
 Port: 3000
)
