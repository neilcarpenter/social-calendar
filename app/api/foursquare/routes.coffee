config     = require "app/config"
creds      = require 'app/creds'
bodyParser = require 'body-parser'

config =
	"secrets" :
		"clientId"     : creds.foursquare.client_id
		"clientSecret" : creds.foursquare.client_secret
		"redirectUrl"  : "#{config.BASE_PATH}/auth/foursquare/callback"

foursquare = require('node-4sq')(config)

###
@param token
@param user_id
###
getCheckins = (req, res) ->

	foursquare.Users.getCheckins req.body.user_id, {}, req.body.token, (err, checkins) ->
		res.json checkins : checkins

setup = (app) ->
	app.use bodyParser()

	app.post '/api/foursquare', getCheckins

module.exports = setup
