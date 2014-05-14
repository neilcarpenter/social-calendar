#!/usr/bin/env node
config  = require "app/config"
express = require "express"
app     = express()

#Use whichever logging system you prefer.
#Doesn't have to be winston, I just wanted something more or less realistic
log = require("winston").loggers.get("app:server")

app.set "views", __dirname
app.set "view engine", "jade"

#See the README about ordering of middleware
#Load the routes ("controllers" -ish)
[
	"app/auth/twitter/routes",
	"app/api/twitter/routes",
	"app/api/facebook/routes",
	"app/site/routes"
].forEach (routePath) ->
	require(routePath)(app)

#FINALLY, use any error handlers
app.use require("app/middleware").notFound

#Note that there's not much logic in this file.
#The server should be mostly "glue" code to set things up and
#then start listening

app.listen config.express.port, config.express.ip, (error) ->
	if error
		log.error("Unable to listen for connections", error)
		process.exit(10)

	log.info("express is listening on " + config.BASE_PATH);
