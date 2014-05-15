creds      = require 'app/creds'
bodyParser = require 'body-parser'
FB         = require 'fb'

###
@param token
###
getPosts = (req, res) ->

	params =
		limit        : 50
		access_token : req.body.token

	FB.api 'me/feed', params, (result) ->
		res.json posts : result

setup = (app) ->
	app.use bodyParser()

	app.post '/api/facebook', getPosts

module.exports = setup
