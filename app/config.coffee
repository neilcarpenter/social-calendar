config = module.exports

config.express =
	port : process.env.EXPRESS_PORT or 3000
	ip   : "127.0.0.1"

config.PRODUCTION = process.env.NODE_ENV is "production"
config.BASE_PATH  = if config.PRODUCTION then "http://neilcarpenter-social-calendar.nodejitsu.com" else "http://#{config.express.ip}:#{config.express.port}"
