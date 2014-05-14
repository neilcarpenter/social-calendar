config     = module.exports
PRODUCTION = process.env.NODE_ENV is "production"

config.express =
	port : process.env.EXPRESS_PORT or 3000
	ip   : "127.0.0.1"

config.BASE_PATH = "http://#{config.express.ip}:#{config.express.port}"
